class ThinksSystem
  include Moon::EntitySystem::System
  register :thinks

  def update(delta)
    teams = {}
    world.filter(:team) do |entity|
      (teams[entity[:team].number] ||= []).push(entity)
    end
    world.filter(:brain, :team, :navigation) do |entity|
      nav = entity[:navigation]
      team = entity[:team]
      target = entity[:target]
      if target
        if t1 = teams[1]
          nav.destination = t1.first[:transform].position
        end
      else
        if t1 = teams[1]
          a = t1.first[:transform].position
          b = entity[:transform].position
          c = (b - a).normalize
          nav.destination = a + (c * 1.2)
        end
      end
    end
  end
end
