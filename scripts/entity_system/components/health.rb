require 'scripts/entity_system/component'

class HealthComponent < ES::EntitySystem::Component
  register :health

  field :value, type: Integer, default: 0
  field :max,   type: Integer, default: 0

  def rate
    value / max.to_f
  end

  def rate=(rate)
    self.value = (rate * max).to_i
  end
end
