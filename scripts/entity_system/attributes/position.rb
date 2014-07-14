class PositionAttribute
  include Component
  register :position

  field :x, type: Integer, default: 0
  field :y, type: Integer, default: 0
end
