require 'scripts/models/map'
require 'scripts/entity_system/component'

module Components
  class Map < Base
    register :map

    field :map, type: Models::Map, default: nil
  end
end
