module Controllers
  # Helper controller for handling text input, this class will handle typing,
  # insert and appending.
  # In order to use this class, simply pass in an Object that responds to
  # `#string` and `#string=`, such as a {Moon::Text} or {Moon::Label}.
  # `:replace` mode will replace characters on the index, while `:append` will
  # add new characters, possibly injecting into the string
  class TextInput
    # @return [#string, #string=]
    attr_reader :target
    # @return [Moon::Input::Observer]
    attr_reader :input
    # @return [Integer]
    attr_accessor :index

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
      when :left      then cursor_prev
      when :right     then cursor_next
      end
    end

    # @param [Integer] inx  index
    def index=(inx)
      @index = inx.clamp(0, @target.string.size)
    end

    # @return [Symbol]
    attr_reader :mode

    # @param [Symbol] mode
    def mode=(mode)
      if mode == :append || mode == :replace
        @mode = mode
      else
        raise ArgumentError,
          "invalid mode #{mode} (expected :append or :replace)"
      end
    end

    # Toggles the mode, if `:replace` switches to `:append`,
    # if `:append` switches to `:replace`
    #
    # @return [self]
    def toggle_input_mode
      self.mode = @mode == :replace ? :append : :replace
      self
    end

    # Move's the cursor back
    #
    # @return [self]
    def cursor_prev
      self.index = @index.pred
      @target.string = @target.string
      self
    end

    # Move's the cursor forward
    #
    # @return [self]
    def cursor_next
      self.index = @index.succ
      @target.string = @target.string
      self
    end

    # @return [self]
    private def modify
      src = @target.string
      return if src.empty?
      return if @index >= src.size
      src = yield src
      @target.string = src
      self
    end

    # Deletes the character to the right of the cursor
    #
    # @return [self]
    def delete
      modify do |src|
        src = (src.slice(0, @index) || '') <<
        (src.slice((@index + 1)..src.size) || '')
        @index = @index.clamp(0, src.size)
        src
      end
    end

    # Deletes the character to the left of the cursor
    #
    # @return [self]
    def backspace
      modify do |src|
        src = (src.slice(0...(@index - 1)) || '') <<
        (src.slice(@index..src.size) || '')
        @index = @index.pred.clamp(0, src.size)
        src
      end
    end

    # Inserts the given string +str+ into the {#target}
    #
    # @param [String] str
    # @return [self]
    def insert(str)
      src = @target.string
      case @mode
      when :append
        src = (src.slice(0, @index) || '') << str <<
          (src.slice(@index..src.size) || '')
      when :replace
        src[@index, str.size] = str
      end
      @index = (@index + str.size).clamp(0, src.size)
      @target.string = src
      self
    end
  end
end
