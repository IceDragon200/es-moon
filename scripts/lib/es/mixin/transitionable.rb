class Transition

  attr_accessor :easer
  attr_accessor :a
  attr_accessor :b
  attr_reader :target
  attr_reader :time
  attr_reader :duration

  def initialize(target, a, b, duration, &block)
    @target = target
    @a = a
    @b = b
    @time = 0
    @duration = duration.to_i
    @easer = Easer::Linear
    @callback = block
  end

  def done?
    @time >= @duration
  end

  def update
    return if done?
    @time += 1
    @callback.(@easer.ease(@a, @b, @time.to_f / @duration))
  end

end

module Transitionable

  def transition(attribute, value, duration=8)
    src = send(attribute)
    setter = "#{attribute}="
    transition = Transition.new(self, src, value, duration) { |v| send(setter, v) }

    (@transitions ||=[]).push transition
    transition
  end

  def update_transition
    return unless @transitions
    return if @transitions.empty?
    dead = []
    @transitions.each do |transition|
      transition.update
      dead << transition if transition.done?
    end
    @transitions -= dead
  end

end