module Moon
  module EntitySystem
    module System
      def render(x, y, z, options)
        #
      end
    end
  end
end

module ES
  class World < Moon::EntitySystem::World
    include Moon::Eventable

    class EntityEvent < Moon::Event
      attr_accessor :entity

      def initialize(entity, type)
        @entity = entity
        super type
      end
    end

    class EntityAddedEvent < EntityEvent
      def initialize(entity)
        super entity, :entity_added
      end
    end

    class EntityRemovedEvent < EntityEvent
      def initialize(entity)
        super entity, :entity_removed
      end
    end

    def initialize
      super
      initialize_eventable
    end

    def on_entity_added(entity)
      trigger EntityAddedEvent.new(entity)
      super
    end

    def on_entity_removed(entity)
      trigger EntityRemovedEvent.new(entity)
      super
    end
  end
end
