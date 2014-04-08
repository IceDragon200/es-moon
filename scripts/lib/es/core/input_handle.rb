class InputHandle

  def initialize(device, selector)
    @device = device
    @selector = selector
  end

  def each_selector(&block)
    @selector.is_a?(Enumerable) ? @selector.each(&block) : yield(@selector)
  end

  def triggered?
    each_selector.any { |s| @device.triggered?(s) }
  end

  def repeated?
    each_selector.any { |s| @device.repeated?(s) }
  end

  def pressed?
    each_selector.any { |s| @device.pressed?(s) }
  end

end