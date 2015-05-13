class MovementSystem
  include Moon::EntitySystem::System
  register :movement

  def init
    super
    @sprite = Moon::Sprite.new(TextureCache.ui('map_editor_cursor.png'))
  end

  def update(delta)
    world.filter(:transform, :navigation, :body) do |entity|
      entity.comp(:transform, :navigation, :body) do |t, n, b|
        dist = t.position.distance(n.destination)
        if dist.abs > 1e-1
          v = t.position.turn_towards(n.destination)
          t.position = t.position + (v * b.speed * delta)
        end
      end
    end
  end

  def render(x, y, z, options)
    world.filter(:navigation) do |e|
      navi = e[:navigation]
      p = navi.destination * 32 + [x, y, z]
      @sprite.render(p.x, p.y, p.z)
    end
  end
end
