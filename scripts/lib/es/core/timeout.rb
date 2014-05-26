class Timeout

  attr_reader :time
  attr_reader :duration
  attr_reader :active

  def initialize(duration, &block)
    @time = @duration = duration
    @trigger = block
    @active = true
  end

  def done?
    @time <= 0
  end

  def update(delta)
    return unless @active
    @time -= delta
    if done?
      @trigger.()
      @active = false
    end
  end

end