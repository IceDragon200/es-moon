require 'scripts/entity_system/component'

class NameComponent < ES::EntitySystem::Component
  register :name

  field :string, field: String, default: 'Anonymous'
end
