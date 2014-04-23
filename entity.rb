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
# don't mind this...
class State
  def initialize
    init
  end
  def init
  end
  def update
  end
  def render
  end
end
# or this
class Vector2
  attr_accessor :x, :y
  def initialize(x, y)
    @x, @y = x, y
  end
end

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

  def self.seed=(seed)
    set_seed seed
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

  self.seed = rand(0xFFFFFFFF)

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

end

# Component as class
class Component
  # Ghost town

  def initialize(options)
    options.each { |key, value| send(key.to_s+"=", value) }
  end

end

# Component as mixin
module MComponent

  def setup(options)
    options.each { |key, value| send(key.to_s+"=", value) }
  end

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

# using inheritance
#class Component::Position < Component
#  attr_accessor :x, :y
#end

# using mixin !?
class Component::Position < Vector2
  include MComponent
  def initialize(options)
    super 0, 0
    setup(options)
  end
end

module System::MoveSystem

  def self.process(delta, world)
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

end


### force invoke

p "seed: #{MoonRandom.seed}"
p "seed: #{MoonRandom.seed = 12}"
state = EntityState.new

count = 120
loop do
  sleep 0.016
  state.update
  count = count.pred
  break if count <= 0
  p "#{count} #{state.inspect}"
end
p state