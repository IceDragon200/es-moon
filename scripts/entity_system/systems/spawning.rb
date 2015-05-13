class SpawningSystem
  include Moon::EntitySystem::System
  register :spawning

  def update(delta)
    world.filter(:spawner) do |entity|
      spawner = entity[:spawner]
      spawner.timer.update(delta)
      if spawner.timer.done?
        template = spawner.template
        world.spawn template do |e|
          e[:transform].position = entity[:transform].position
        end
        spawner.timer.restart
      end
    end
  end
end
