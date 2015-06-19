require 'scripts/entity_system/component'

class NavigationComponent < ES::EntitySystem::Component
  register :navigation

  field :destination, type: Moon::Vector3
end
