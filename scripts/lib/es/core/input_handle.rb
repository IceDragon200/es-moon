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
    each_selector { |s| return true if @device.triggered?(s, @modifier) }
    false
  end

  def repeated?
    each_selector { |s| return true if @device.repeated?(s, @modifier) }
    false
  end

  def pressed?
    each_selector { |s| return true if @device.pressed?(s, @modifier) }
    false
  end

end