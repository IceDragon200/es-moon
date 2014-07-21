class InputContext
  def initialize(input, &block)
    @input = input
    @wrap_function = block
  end

  def on(*args, &block)
    @wrap_function.call :on, @input, *args, &block
  end

  def typing(*args, &block)
    @wrap_function.call :typing, @input, *args, &block
  end
end
