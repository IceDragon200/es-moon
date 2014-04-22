#+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
#  Entity System proposal
#---- TODO -------------------------------------------------------------
#  - ability to fetch component aggregates in system
#
#  - ability to tag entities
#  - ability to fetch entities
#  - ability to fetch entity components trough entity
#  - ability to fetch entities by specific queries?
#  - ability to "import" components from a db preset (.dup and add them)
#+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+

module System
  
  def self.process(delta, world)
  end

end

class World

  # @components = { ComponentClass => {entity_id => [component, ...], ...}, ...}
  def initialize
    @components = Hash.new { |hash, key| hash[key] = {} } # subkeys always initialized to {}
    @entities = []
    @systems = []
  end

  # Entities

  def spawn # new entity
    entity = Entity.new
    @entities << entity
    return entity
  end

  # Components

  # not to be used directly
  def add_component(id, component)
    sym = component.class.to_s.downcase
    (@components[sym][id] ||= []) << component
  end

  def [](component) # maybe just @components[component] ?
    @components[component].values.flatten
  end

  # Systems

  def register(system)
    @systems << system 
  end

  #---

  def update # parallelize in the future
    @systems.each do |system|
      # todo delta
      delta = 0.0
      system.perform(delta, self)
    end
  end

end

class Component
   # Ghost town
end

class Entity

  def initialize(world)
    @world = world
  end

  def add(component)
    @world.add_component(self.id, component)
    return component.id
  end

end


# Example usage

class Component::Position < Component
  attr_accessor :x, :y
end

module System::MoveSystem
  def self.process(delta, world)
    world[:position].each do |pos|

      pos.x += 1
      pos.y += 1

    end
  end
end

class EntityState < State

  def initialize
    super

    @world = World.new
    @world.register(System::MoveSystem)
    create_player
  end

  def create_player
    player = @world.spawn
    player.add(Component::Position.new(2,1))
  end

  def update
    @world.update
    super
  end

  def render
    super
  end
end