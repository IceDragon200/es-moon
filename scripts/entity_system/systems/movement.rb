module MovementSystem
  extend Moon::System
  register :movement

  def self.process(delta, world)
    world.entities.each do |entity|
      pos = entity[:position]
      vel = entity[:velocity]
      pos.x += vel.x * delta if vel.x != 0
      pos.y += vel.y * delta if vel.y != 0
    end
  end
end
