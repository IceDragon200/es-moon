class VelocityAttribute
  include Moon::Component
  register :velocity

  field :x, type: Integer, default: 0
  field :y, type: Integer, default: 0
end
