module Transitionable

  ###
  # @param [String] attribute
  #   @example "color"
  #   @example "position.x"
  # @param [Object] value  target value
  # @param [Numeric] duration  in seconds
  ###
  def transition(attribute, value, duration=0.15)
    attribute = attribute.to_s
    rolling = attribute.split(".")
    if rolling.size > 1
      src = rolling.inject(self) { |obj, param| obj.send(param) }
      setter = "#{rolling.pop}="
      transition = Transition.new(src, value, duration) do |v|
        rolling.inject(self) { |obj, param| obj.send(param) }.send(setter, v)
      end
    else
      src = send(attribute)
      setter = "#{attribute}="
      transition = Transition.new(src, value, duration) { |v| send(setter, v) }
    end

    (@transitions ||=[]).push transition
    transition
  end

  def update_transition(delta)
    return unless @transitions
    return if @transitions.empty?
    dead = []
    @transitions.each do |transition|
      transition.update(delta)
      dead << transition if transition.done?
    end
    @transitions -= dead
  end

end