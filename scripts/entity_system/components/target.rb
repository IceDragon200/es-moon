require 'scripts/entity_system/component'

module Components
  class Target < Base
    register :target

    field :target, type: Moon::EntitySystem::Entity, default: nil
  end
end
