require 'scripts/entity_system/component'

module Components
  # Component responsible for placing objects on the map
  # This is combined with the map system for converting the
  # relative map position to a world renderable position
  class Mapobj < Base
    register :mapobj

    field :position, type: Moon::Vector2, default: ->(t, _) { t.model.new }
    field :map_id, type: String, default: ''
  end
end
