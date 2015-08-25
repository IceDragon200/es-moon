require 'scripts/entity_system/component'

class MapComponent < ES::EntitySystem::Component
  register :map

  field :map, type: ES::Map, default: nil
end
