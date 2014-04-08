class InputHandle

  def initialize(device, selector)
    @device = device
    @selector = selector
  end

  def triggered?
    @device.triggered?(@selector)
  end

  def repeated?
    @device.repeated?(@selector)
  end

  def pressed?
    @device.pressed?(@selector)
  end

end