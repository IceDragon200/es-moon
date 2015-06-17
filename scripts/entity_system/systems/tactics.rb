module Phases
  module Base
    include Enum::TacticsPhase

    def goto_and_idle(tactics, new_phase)
      tactics.next_phase = new_phase
      tactics.idle = true
    end

    # @param [TacticsComponent] tactics
    def process(tactics, world, delta)
    end
  end

  module Judge
  end

  class Idle
    include Base
  end

  class BattleStart
    include Base

    # (see Base#process)
    def process(tactics, world, delta)
      tactics.battle_wt = 0
      tactics.rounds = 0
      tactics.subject_id = nil
      # reset all entities wait_time to its maximum
      world.filter(:wait_time) do |entity|
        wt = entity[:wait_time]
        wt.value = wt.max
      end
      goto_and_idle tactics, ROUND_NEXT
    end
  end

  class RoundNext
    include Base

    # (see Base#process)
    def process(tactics, world, delta)
      tactics.rounds += 1
      tactics.round_wt = tactics.round_wt_max
      goto_and_idle tactics, ROUND_START
    end
  end

  class RoundStart
    include Base

    # (see Base#process)
    def process(tactics, world, delta)
      goto_and_idle tactics, NEXT_TICK
    end
  end

  class NextTick
    include Base

    # (see Base#process)
    def process(tactics, world, delta)
      entities = world[:wait_time]
      if entities.empty?
        # there are no valid entities to conduct battle
        goto_and_idle tactics, BATTLE_END
      else
        # grab the entity with the shortest wait_time
        entity = entities.min_by { |e| e[:wait_time].value }
        wt = entity[:wait_time]
        diff = wt.value
        r = tactics.round_wt - diff
        # determine if the entity can have its turn within the current round
        if r < 0
          # the entity would overstep the current round, set the diff as
          # the remaining ticks in the round
          diff = tactics.round_wt
          tactics.subject_id = nil
          goto_and_idle tactics, ROUND_END
        else
          # the entity can act in the current round
          tactics.subject_id = entity.id
          goto_and_idle tactics, TURN_START
        end
        # decrease all entities round_wt by the diff
        entities.each do |entity|
          entity[:wait_time].value -= diff
        end
        # decreate the round_wt by the diff
        tactics.round_wt -= diff
        # increase the battle_wt by the diff
        tactics.battle_wt += diff
      end
    end
  end

  class TurnStart
    include Base

    # (see Base#process)
    def process(tactics, world, delta)
      if entity = world.get_entity_by_id(tactics.subject_id)
        wt = entity[:wait_time]
        #wt.reset = 0
        wt.reset = wt.max
      end
      goto_and_idle tactics, ACTION_NEXT
    end
  end

  class ActionNext
    include Base

    # (see Base#process)
    def process(tactics, world, delta)
      #goto_and_idle tactics, ACTION_MAKE
      goto_and_idle tactics, TURN_END
    end
  end

  class ActionMake
    include Base

    # (see Base#process)
    def process(tactics, world, delta)
      goto_and_idle tactics, ACTION_PREPARE
    end
  end

  class ActionPrepare
    include Base

    # (see Base#process)
    def process(tactics, world, delta)
      goto_and_idle tactics, ACTION_EXECUTE
    end
  end

  class ActionExecute
    include Base

    # (see Base#process)
    def process(tactics, world, delta)
      goto_and_idle tactics, ACTION_JUDGE
    end
  end

  class ActionJudge
    include Base
    include Judge

    # (see Base#process)
    def process(tactics, world, delta)
      goto_and_idle tactics, ACTION_NEXT
      #goto_and_idle tactics, BATTLE_END
    end
  end

  class TurnEnd
    include Base

    # (see Base#process)
    def process(tactics, world, delta)
      if entity = world.get_entity_by_id(tactics.subject_id)
        wt = entity[:wait_time]
        wt.value += wt.reset
      end
      goto_and_idle tactics, TURN_JUDGE
    end
  end

  class TurnJudge
    include Base
    include Judge

    # (see Base#process)
    def process(tactics, world, delta)
      goto_and_idle tactics, NEXT_TICK
      #goto_and_idle tactics, BATTLE_END
    end
  end

  class RoundEnd
    include Base

    # (see Base#process)
    def process(tactics, world, delta)
      puts "Round End"
      goto_and_idle tactics, ROUND_JUDGE
    end
  end

  class RoundJudge
    include Base
    include Judge

    # (see Base#process)
    def process(tactics, world, delta)
      goto_and_idle tactics, ROUND_NEXT
      #goto_and_idle tactics, BATTLE_END
    end
  end

  class BattleEnd
    include Base

    # (see Base#process)
    def process(tactics, world, delta)
      goto_and_idle tactics, BATTLE_JUDGE
    end
  end

  class BattleJudge
    include Base
    include Judge

    # (see Base#process)
    def process(tactics, world, delta)
    end
  end

  PHASE_TABLE = {
    # oh great, glorified function mappings Yaaay.
    Enum::TacticsPhase::IDLE           => Idle,
    Enum::TacticsPhase::BATTLE_START   => BattleStart,
    Enum::TacticsPhase::ROUND_NEXT     => RoundNext,
    Enum::TacticsPhase::ROUND_START    => RoundStart,
    Enum::TacticsPhase::NEXT_TICK      => NextTick,
    Enum::TacticsPhase::TURN_START     => TurnStart,
    Enum::TacticsPhase::ACTION_NEXT    => ActionNext,
    Enum::TacticsPhase::ACTION_MAKE    => ActionMake,
    Enum::TacticsPhase::ACTION_PREPARE => ActionPrepare,
    Enum::TacticsPhase::ACTION_EXECUTE => ActionExecute,
    Enum::TacticsPhase::ACTION_JUDGE   => ActionJudge,
    Enum::TacticsPhase::TURN_END       => TurnEnd,
    Enum::TacticsPhase::TURN_JUDGE     => TurnJudge,
    Enum::TacticsPhase::ROUND_END      => RoundEnd,
    Enum::TacticsPhase::ROUND_JUDGE    => RoundJudge,
    Enum::TacticsPhase::BATTLE_END     => BattleEnd,
    Enum::TacticsPhase::BATTLE_JUDGE   => BattleJudge,
  }
end

class TacticsSystem
  include Moon::EntitySystem::System
  include Enum::TacticsPhase
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

  def update(delta)
    # retrieve the tactics model
    world.filter(:tactics) do |entity|
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
