# Example usage

class Component::Position < Vector2
  include Component

  field :x, type: Integer, default: 0
  field :y, type: Integer, default: 0

  def initialize(options={})
    super 0, 0
    setup(options)
  end

end

class Component::Sprite
  include Component

  field :sprite, type: Integer, default: 0

  def initialize(options={})
    setup(options)
  end

end

class Component::PixieDust
  include Component

  # Component will lazily take the class name and downcase it for registering
  # you can always register a component using the register function again
  register :pixie_dust

  field :dust, type: Integer, default: 0

  def initialize(options={})
    setup(options)
  end

end

module System::Movement
  extend System

  def self.process(delta, world)
    world[:position].each do |entity|
      pos = entity[:position]

      pos.x += 1 * delta
      pos.y += 1 * delta
    end
  end

end

module System::Rendering
  extend System

  def self.process(delta, world)
    entities = world[:position, :sprite]
    puts entities.count

    entities.each do |entity|
      pos = entity[:position]

      pos.x += 1 * delta
      pos.y += 1 * delta
    end
  end

end

class EntityState < State

  attr_reader :world

  def init
    super

    @world = World.new
    @world.register(System::Movement)
    @world.register(System::Rendering)
    create_player
    50.times { create_entity }
  end

  def create_player
    player = @world.spawn
    # just proof that Component[] works
    player.add Component[:position].new(x: 2, y: 1)
    player.add Component[:sprite].new
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
world = state.world
puts "seed: #{world.random.seed}"
puts "seed: #{world.random.seed = 12}"

puts Component.list
#puts world.components

120.times do
  state.update
end

dump = YAML.dump(world.export)
puts dump
data = YAML.load(dump)
puts data
world = World.load data
puts data
puts world.to_h
