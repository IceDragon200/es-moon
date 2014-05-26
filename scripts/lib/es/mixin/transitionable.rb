module Transitionable

  include TransitionHost

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
      add_transition(src, value, duration) do |v|
        rolling.inject(self) { |obj, param| obj.send(param) }.send(setter, v)
      end
    else
      src = send(attribute)
      setter = "#{attribute}="
      add_transition(src, value, duration) { |v| send(setter, v) }
    end
  end

end