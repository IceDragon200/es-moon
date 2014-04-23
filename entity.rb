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

  def process(delta, world)
    #
  end

  def to_h
    {
      class: to_s
    }
  end

  def export
    to_h.stringify_keys
  end

  def import(data)
    self
  end

  def self.load(data)
    Object.const_get(data["class"])
  end

end

class World
  attr_reader :random

  # @components = { ComponentClass => {entity_id => [component, ...], ...}, ...}
  def initialize
    @random = Moon::SeedRandom.new
    @components = Hash.new { |hash, key| hash[key] = {} } # subkeys always initialized to {}
    @entities = []
    @systems = []
  end

  # Entities

  def spawn # new entity
    entity = Entity.new self
    @entities << entity
    return entity
  end

  # Components

  # not to be used directly
  def add_component(id, component)
    #sym = component.class.to_s.demodulize.downcase.to_sym # this is the sweetest thing...
    key = component.class
    (@components[key][id] ||= []) << component
    component
  end

  def [](klass) # maybe just @components[component] ?
    @components[klass].values.flatten
  end

  # Systems

  def register(system)
    @systems << system
  end

  #---

  def update(delta) # parallelize in the future
    @systems.each do |system|
      system.process(delta, self)
    end
  end

  def to_h
    {
      components: @components,
      entities: @entities,
      systems: @systems
    }
  end

  def export
    components = @components.each_with_object({}) do |d, comp_hash|
      component_klass, comps = *d
      entities = comps.each_with_object({}) do |a, hsh|
        eid, comp = *a
        hsh[eid] = comp.map { |c| c.export }
      end
      comp_hash[component_klass.to_s] = entities
    end
    {
      "random"     => @random.export,
      "components" => components,
      "systems"    => @systems.map { |sys| sys.export },
      "entities"   => @entities.map { |entity| entity.export }
    }
  end

  def import(data)
    @random = Moon::SeedRandom.load(data["random"])
    @components = data["components"].each_with_object({}) do |d, comp_hash|
      component_klass, comps = *d
      entities = comps.each_with_object({}) do |a, hsh|
        eid, comp = *a
        hsh[eid] = comp.map { |c| Component.load(c) }
      end
      comp_hash[component_klass.to_s] = entities
    end
    @entities = data["entities"].map do |d|
      Entity.new(self).import(d)
    end
    @systems = data["systems"].map do |d|
      System.load(d)
    end
    self
  end

  def self.load(data)
    new.import(data)
  end

end

# Component as mixin
module Component

  module ComponentClass

    def field(name, data)
      (@fields ||= {})[name] = data
      attr_reader name unless method_defined?(name)
      attr_writer name.to_s+"=" unless method_defined?(name.to_s+"=")
    end

    def fields
      @fields ||= {}
      if superclass.respond_to?(:fields)
        superclass.fields.merge(@fields)
      else
        @fields
      end
    end

  end

  def setup(options={})
    self.class.fields.each do |key, data|
      send(key.to_s+"=", data[:default]) if data.key?(:default)
      send(key.to_s+"=", options[key]) if options.key?(key)
    end
  end

  def export
    to_h.merge(class: self.class.to_s).stringify_keys
  end

  def import(data)
    setup(data)
    self
  end

  def self.included(mod)
    mod.extend ComponentClass
  end

  def self.load(data)
    Object.const_get(data["class"]).new(data.symbolize_keys)
  end

  private :setup

end

class Entity

  attr_reader :id

  def initialize(world)
    @world = world
    @id = @world.random.base64 16 # right within ruby's optimal string length
  end

  def add(component)
    @world.add_component(@id, component)
    component
  end

  def to_h
    {
      id: @id
    }
  end

  def export
    to_h.stringify_keys
  end

  def import(data)
    @id = data["id"]
    self
  end

end


# Example usage

# using mixin !?
class Component::Position < Vector2
  include Component

  field :x, type: Integer, default: 0
  field :y, type: Integer, default: 0

  def initialize(options={})
    super 0, 0
    setup(options)
  end

end

module System::Movement
  extend System

  def self.process(delta, world)
    super delta, world
    world[Component::Position].each do |pos|

      pos.x += 1 * delta
      pos.y += 1 * delta

    end
  end

end

class EntityState < State

  def init
    super

    @world = World.new
    @world.register(System::Movement)
    create_player
    50.times { create_entity }
  end

  def create_player
    player = @world.spawn
    player.add Component::Position.new(x: 2, y: 1)
  end

  def create_entity
    entity = @world.spawn
    entity.add Component::Position.new(x: @world.random.int(100),
                                       y: @world.random.int(100))
  end

  def update
    @world.update(0.016)
    super
  end

  def render
    #
    super
  end

end


### force invoke

state = EntityState.new(nil)
state.init
world = state.instance_variable_get("@world")
puts "seed: #{world.random.seed}"
puts "seed: #{world.random.seed = 12}"

count = 120
loop do
  state.update
  count -= 1
  break if count <= 0
end
dump = YAML.dump(world.export)
puts dump
data = YAML.load(dump)
puts data
world = World.load data["world"]
puts data["world"]
puts world.to_h
