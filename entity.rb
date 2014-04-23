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
module MoonRandom

  class << self
    attr_accessor :seed
    attr_accessor :random
    alias :set_seed :seed=
    private :set_seed
  end

  BINARY_DIGITS = %w[0 1]
  OCTAL_DIGITS  = %w[0 1 2 3 4 5 6 7]
  HEX_DIGITS    = %w[0 1 2 3 4 5 6 7 8 9 A B C D E F]
  BASE64_DIGITS = %w[A B C D E F G H I J K L M N O P Q R S T U V W X Y Z] +
                  %w[a b c d e f g h i j k l m n o p q r s t u v w x y z] +
                  %w[0 1 2 3 4 5 6 7 8 9 + /]

  def self.seed=(_seed)
    set_seed _seed.to_i
    self.random = Random.new(self.seed)
  end

  def self.int(size)
    random.rand(size)
  end

  def self.sample(array)
    array[int(array.size)]
  end

  def self.binary(digits)
    digits.times.map { sample(BINARY_DIGITS) }.join("")
  end

  def self.octal(digits)
    digits.times.map { sample(OCTAL_DIGITS) }.join("")
  end

  def self.hex(digits)
    digits.times.map { sample(HEX_DIGITS) }.join("")
  end

  def self.base64(digits)
    digits.times.map { sample(BASE64_DIGITS) }.join("")
  end

  self.seed = rand(0xFFFFFFF)

end

module System

  def self.process(delta, world)
    #
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
    entity = Entity.new self
    @entities << entity
    return entity
  end

  # Components

  # not to be used directly
  def add_component(id, component)
    #sym = component.class.to_s.demodulize.downcase.to_sym # this is the sweetest thing...
    key = component.class
    ## wouldn't this mean we'd map components by entities?
    (@components[key][id] ||= []) << component
    component
  end

  def [](component_klass) # maybe just @components[component] ?
    @components[component_klass].values.flatten
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
    components = @components.map do |component_klass, comps|
      entities = comps.map { |eid, comp| [eid, comp.map { |c| c.to_h }] }
      [component_klass.to_s, entities]
    end
    {
      components: components,
      systems: @systems.map { |sys| sys.to_h }
    }
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

  def self.included(mod)
    mod.extend ComponentClass
  end

  private :setup

end

class Entity

  attr_reader :id

  def initialize(world)
    @world = world
    @id = MoonRandom.base64 16 # right within ruby's optimal string length
  end

  def add(component)
    @world.add_component(@id, component)
    component
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

  #def to_h
  #  super.merge class: self.class.to_s
  #end

end

module System::MoveSystem

  def self.process(delta, world)
    world[Component::Position].each do |pos|

      pos.x += 1 * delta
      pos.y += 1 * delta

    end
  end

  def self.to_h
    {
      class: to_s
    }
  end

end

class EntityState < State

  def init
    super

    @world = World.new
    @world.register(System::MoveSystem)
    create_player
    50.times { create_entity }
  end

  def create_player
    player = @world.spawn
    player.add Component::Position.new(x: 2, y: 1)
  end

  def create_entity
    entity = @world.spawn
    entity.add Component::Position.new(x: MoonRandom.int(100),
                                       y: MoonRandom.int(100))
  end

  def update
    @world.update(0.016)
    super
  end

  def render
    #
    super
  end

  def to_h
    {
      world: @world.to_h
    }
  end

end


### force invoke

p "seed: #{MoonRandom.seed}"
p "seed: #{MoonRandom.seed = 12}"
state = EntityState.new(nil)
state.init

count = 120
loop do
  state.update
  count -= 1
  break if count <= 0
end
puts YAML.dump(state.to_h)