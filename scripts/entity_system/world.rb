require 'entity_system/world'

module ES
  module EntitySystem
    class World < Moon::EntitySystem::World
      include Moon::Eventable

      class EntityEvent < Moon::Event
        attr_accessor :entity

        def initialize(entity, type)
          @entity = entity
          super type
        end
      end

      def initialize
        super
        initialize_eventable
      end

      def on_entity_added(entity)
        trigger EntityEvent.new(entity, :entity_added)
        super
      end

      def on_entity_removed(entity)
        trigger EntityEvent.new(entity, :entity_removed)
        super
      end
    end
  end
end
