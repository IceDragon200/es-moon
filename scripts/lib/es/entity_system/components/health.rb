class Component::Health
  include Component

  field :value, type: Integer, default: 0
  field :max, type: Integer, default: 0
end
