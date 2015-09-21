require 'scripts/entity_system/system'
require 'scripts/entity_system/components/team'
require 'scripts/entity_system/components/brain'
require 'scripts/entity_system/components/transform'

module Systems
  class ThinksSystem < Base
    register :thinks

    def update(delta)
      teams = {}
      world.filter(:team) do |entity|
        (teams[entity[:team].number] ||= []).push(entity)
      end
      world.filter(:brain, :team, :movement) do |entity|
        mv = entity[:movement]
        team = entity[:team]
      end
    end
  end
end
