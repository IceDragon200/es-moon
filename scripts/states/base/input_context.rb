class InputContext
  def initialize(input, &block)
    @input = input
    @wrap_function = block
  end

  def on(*args, &block)
    @wrap_function.call @input, *args, &block
  end
end
