class InputHandle

  attr_accessor :device
  attr_accessor :selector
  attr_accessor :modifier

  def initialize(device, selector, modifier=0)
    @device = device
    @selector = selector
    @modifier = modifier
  end

  def each_selector(&block)
    @selector.is_a?(Enumerable) ? @selector.each(&block) : yield(@selector)
  end

  def triggered?
    each_selector.any { |s| @device.triggered?(s, @modifier) }
  end

  def repeated?
    each_selector.any { |s| @device.repeated?(s, @modifier) }
  end

  def pressed?
    each_selector.any { |s| @device.pressed?(s, @modifier) }
  end

end