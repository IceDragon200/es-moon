require 'scripts/entity_system/system'
require 'scripts/entity_system/system/processing'
require 'scripts/entity_system/systems/tactics/phases'
require 'scripts/entity_system/components/tactics'

module Systems
  class Tactics < Base
    include ES::EntitySystem::System::Processing

    register :tactics

    def post_initialize
      super
      initialize_phases
    end

    def initialize_phases
      @phases = {}
      Phases::PHASE_TABLE.each_pair do |key, klass|
        @phases[key] = klass.new
      end
    end

    def filtered(&block)
      world.filter(:tactics, &block)
    end

    def process(entity, delta)
      tactics = entity[:tactics]
      until tactics.idle
        if tactics.next_phase != Enum::TacticsPhase::INVALID
          tactics.phase = tactics.next_phase
        end
        if phase = @phases[tactics.phase]
          phase.process(tactics, world, delta)
        else
          puts "warning: Tactics is in an invalid phase!"
        end
      end
    end
  end
end
