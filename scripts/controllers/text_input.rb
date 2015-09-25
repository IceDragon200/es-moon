module Controllers
  # Helper controller for handling text input, this class will handle typing,
  # insert and appending.
  # In order to use this class, simply pass in an Object that responds to
  # #string and #string=, such as a Moon::Text or Moon::Label
  class TextInput
    # @return [#string, #string=]
    attr_reader :target
    # @return [Moon::Input::Observer]
    attr_reader :input
    # @return [Integer]
    attr_accessor :index
    # @return [Symbol]
    attr_accessor :mode

    def initialize(target)
      @target = target
      @index = target.string.size
      @mode = :append
      @input = Moon::Input::Observer.new

      @input.typing { |e| insert e.char }
      @input.on([:press, :repeat]) { |e| handle_input_event(e) }
    end

    # @param [InputEvent] event
    private def handle_input_event(event)
      case event.key
      when :backspace
        erase
      when :insert
        @mode = @mode == :insert ? :append : :insert
      when :left
        cursor_prev
      when :right
        cursor_next
      end
    end

    # @param [Integer] inx  index
    def index=(inx)
      @index = inx.clamp(0, @target.string.size)
    end

    def cursor_prev
      self.index = @index.pred
      @target.string = @target.string
    end

    def cursor_next
      self.index = @index.succ
      @target.string = @target.string
    end

    def erase
      src = @target.string
      src = (src.slice(0...(@index - 1)) || '') +
            (src.slice(@index..src.size) || '')
      @index = @index.pred.clamp(0, src.size)
      @target.string = src
    end

    # @param [String] str
    def insert(str)
      src = @target.string
      case @mode
      when :append
        src = (src.slice(0, @index) || '') +
          str +
          (src.slice(@index..src.size) || '')
      when :insert
        src[@index] = str
      end
      @index = (@index + str.size).clamp(0, src.size)
      @target.string = src
    end
  end
end
