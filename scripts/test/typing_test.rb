class StateTypingTest < State
  def init
    super
    @text = Text.new("", ES.cache.font("uni0553", 16))
    @input.typing do |event|
      p(@text.string += event.char)
    end
    @input.on :press, :backspace do
      @text.string = @text.string[0, @text.string.size-1]
    end
  end

  def update(delta)
    super
  end

  def render
    super
    @text.render 0, 0, 0
  end
end
