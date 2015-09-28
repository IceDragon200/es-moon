require 'scripts/entity_system/component'

module Components
  # Component responsible for placing objects on the map
  # This is combined with the map system for converting the
  # relative map position to a world renderable position
  class Mapobj < Base
    register :mapobj

    field :position, type: Moon::Vector2, default: ->(t, _) { t.model.new }
    field :real_position, type: Moon::Vector2, default: ->(t, _) { t.model.new }
    field :map_id, type: String, default: ''
    field :moving, type: Boolean, default: false

    # @param [Numeric] x
    # @param [Numeric] y
    # @return [self]
    def move_to(x, y)
      real_position.x = position.x = x
      real_position.y = position.y = y
      self
    end
  end
end
