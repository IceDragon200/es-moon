require 'entity_system/system'

module Systems
  class Base
    include Moon::EntitySystem::System

    attr_accessor :game
  end
end
