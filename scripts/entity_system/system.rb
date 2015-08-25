require 'entity_system/system'

module ES
  module EntitySystem
    class System
      include Moon::EntitySystem::System

      attr_accessor :game
    end
  end
end
