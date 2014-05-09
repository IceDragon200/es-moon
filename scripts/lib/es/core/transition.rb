class Transition

  attr_accessor :easer
  attr_accessor :src
  attr_accessor :dest
  attr_reader :time
  attr_reader :duration

  def initialize(src, dest, duration, &block)
    @src = src
    @dest = dest
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
    @callback.(@easer.ease(@src, @dest, @time / @duration))
  end

end