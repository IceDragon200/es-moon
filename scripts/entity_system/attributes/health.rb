class HealthAttribute
  include Component
  register :health

  field :value, type: Integer, default: 0
  field :max,   type: Integer, default: 0
end
