require 'scripts/entity_system/component'

module Components
  class Map < Base
    register :map

    field :map, type: ES::Map, default: nil
  end
end
