class Transition

  attr_accessor :easer
  attr_accessor :a
  attr_accessor :b
  attr_reader :time
  attr_reader :duration

  def initialize(a, b, duration, &block)
    @a = a
    @b = b
    @time = 0.0
    @duration = duration
    @easer = Easer::Linear
    @callback = block
  end

  def done?
    @time >= @duration
  end

  def update(delta)
    return if done?
    @time += delta
    @time = @duration if @time > @duration
    @callback.(@easer.ease(@a, @b, @time / @duration))
  end

end