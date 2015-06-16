class TacticsSystem
  include Moon::EntitySystem::System
  include Enum::TacticsPhase

  register :tactics

  def battle_start(tactics)
    tactics.battle_wt = 0
    tactics.rounds = 0
    tactics.subject = nil
    tactics.phase = ROUND_NEXT
  end

  def round_next(tactics)
    tactics.rounds += 1
    tactics.round_wt = tactics.round_wt_max
    tactics.phase = NEXT_TICK
  end

  def next_tick(tactics)
    entities = world[:wait_time]
    if entities.empty?
      # there are no valid entities to conduct battle
      tactics.phase = BATTLE_END
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
        tactics.subject = nil
        tactics.phase = ROUND_END
      else
        # the entity can act in the current round
        tactics.subject = entity.id
        tactics.phase = TURN_START
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

  def turn_start(tactics)
    tactics.phase = ACTION_NEXT
  end

  def action_next(tactics)
    #tactics.phase = ACTION_MAKE
    tactics.phase = TURN_END
  end

  def action_make(tactics)
    tactics.phase = ACTION_PREPARE
  end

  def action_prepare(tactics)
    tactics.phase = ACTION_EXECUTE
  end

  def action_execute(tactics)
    tactics.phase = ACTION_JUDGE
  end

  def action_judge(tactics)
    tactics.phase = ACTION_NEXT
    #tactics.phase = BATTLE_END
  end

  def turn_end(tactics)
    if entity = world.get_entity_by_id(tactics.subject)
      wt = entity[:wait_time]
      wt.value += wt.max
    end
    tactics.phase = TURN_JUDGE
  end

  def turn_judge(tactics)
    tactics.phase = NEXT_TICK
    #tactics.phase = BATTLE_END
  end

  def round_end(tactics)
    puts "Round End"
    tactics.phase = ROUND_JUDGE
  end

  def round_judge(tactics)
    tactics.phase = ROUND_NEXT
    #tactics.phase = BATTLE_END
  end

  def battle_end(tactics)
    tactics.phase = BATTLE_JUDGE
  end

  def battle_judge(tactics)
  end

  def update(delta)
    # retrieve the tactics model
    world.filter(:tactics) do |entity|
      tactics = entity[:tactics]
      case tactics.phase
      when IDLE
        # do nothing
      when BATTLE_START
        battle_start tactics
      when ROUND_NEXT
        round_next tactics
      when ROUND_START
        round_start tactics
      when NEXT_TICK
        next_tick tactics
      when TURN_START
        turn_start tactics
      when ACTION_NEXT
        action_next tactics
      when ACTION_MAKE
        action_make tactics
      when ACTION_PREPARE
        action_prepare tactics
      when ACTION_EXECUTE
        action_execute tactics
      when ACTION_JUDGE
        action_judge tactics
      when TURN_END
        turn_end tactics
      when TURN_JUDGE
        turn_judge tactics
      when ROUND_END
        round_end tactics
      when ROUND_JUDGE
        round_judge tactics
      when BATTLE_END
        battle_end tactics
      when BATTLE_JUDGE
        battle_judge tactics
      else
        puts "warning: Tactics is in an invalid phase!"
      end
    end
  end
end
