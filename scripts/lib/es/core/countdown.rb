class Countdown

  def initialize(n)
    @ticks = @ticks_max = n.to_i
  end

  def done?
    @ticks <= 0
  end

  def update
    @ticks -= 1 if @ticks > 0
  end

  def rate
    @ticks.to_f / @ticks_max
  end

end