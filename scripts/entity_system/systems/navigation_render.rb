require 'scripts/entity_system/system'

class NavigationRenderSystem < ES::EntitySystem::System
  register :navigation_render

  def render(x, y, z, options)
    world.filter(:navigation) do |e|
      navi = e[:navigation]
      p = navi.destination * 32 + [x, y, z]
      @sprite.render(p.x, p.y, p.z)
    end
  end
end
