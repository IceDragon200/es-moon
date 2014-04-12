class Countdown

  attr_reader :ticks
  attr_reader :ticks_max

  def initialize(n)
    setup(n)
  end

  def setup(n)
    @ticks = @ticks_max = n.to_i
  end

  def reset
    @ticks = @ticks_max
  end

  def done?
    @ticks <= 0
  end

  def update
    @ticks -= 1 if @ticks > 0
  end

  def rate
    1 - (@ticks.to_f / @ticks_max)
  end

end