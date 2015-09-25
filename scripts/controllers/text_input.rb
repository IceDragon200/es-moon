module Controllers
  # Helper controller for handling text input, this class will handle typing,
  # insert and appending.
  # In order to use this class, simply pass in an Object that responds to
  # #string and #string=, such as a Moon::Text or Moon::Label.
  # :insert mode will replace characters on the index, while :append will
  # add new characters, possibly injecting into the string
  class TextInput
    # @return [#string, #string=]
    attr_reader :target
    # @return [Moon::Input::Observer]
    attr_reader :input
    # @return [Integer]
    attr_accessor :index
    # @return [Symbol]
    attr_accessor :mode

    # @param [#string, #string=] target
    def initialize(target, options = {})
      @target = target
      @index = options.fetch(:index, target.string.size)
      @mode = options.fetch(:mode, :append)
      initialize_events
    end

    private def initialize_events
      @input = Moon::Input::Observer.new
      @input.typing { |e| insert e.char }
      @input.on([:press, :repeat]) { |e| handle_input_event(e) }
    end

    # @param [InputEvent] event
    private def handle_input_event(event)
      case event.key
      when :backspace then backspace
      when :delete    then delete
      when :insert    then toggle_input_mode
      when :left  then cursor_prev
      when :right then cursor_next
      end
    end

    # @param [Integer] inx  index
    def index=(inx)
      @index = inx.clamp(0, @target.string.size)
    end

    # Toggles the mode, if insert switches to append, if append switches to
    # insert
    def toggle_input_mode
      @mode = @mode == :insert ? :append : :insert
    end

    # move's the cursor back
    def cursor_prev
      self.index = @index.pred
      @target.string = @target.string
    end

    # move's the cursor forward
    def cursor_next
      self.index = @index.succ
      @target.string = @target.string
    end

    private def modify
      src = @target.string
      return if src.empty?
      return if @index >= src.size
      src = yield src
      @index = @index.pred.clamp(0, src.size)
      @target.string = src
    end

    # Deletes the character to the right of the cursor
    def delete
      modify do |src|
        (src.slice(0, @index) || '') <<
        (src.slice((@index + 1)..src.size) || '')
      end
    end

    # Deletes the character to the left of the cursor
    def backspace
      modify do |src|
        (src.slice(0...(@index - 1)) || '') <<
        (src.slice(@index..src.size) || '')
      end
    end

    # @param [String] str
    def insert(str)
      src = @target.string
      case @mode
      when :append
        src = (src.slice(0, @index) || '') << str <<
          (src.slice(@index..src.size) || '')
      when :insert
        src[@index] = str
      end
      @index = (@index + str.size).clamp(0, src.size)
      @target.string = src
    end
  end
end
