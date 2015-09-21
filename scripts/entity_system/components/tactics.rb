require 'scripts/entity_system/component'

module Components
  class TacticalComponent < Base
    register :tactics

    # whether the tactics is currently idling, this causes the tactics system to
    # skip the component for processing, ultimately halting the phase process.
    field :idle,         type: Boolean, default: false

    # current acting entity's ID
    field :subject_id,   type: String,  default: nil

    # current phase
    field :phase,        type: Integer, default: Enum::TacticsPhase::INVALID

    # next phase to goto
    field :next_phase,   type: Integer, default: Enum::TacticsPhase::INVALID

    # rounds passed so far in the current battle
    field :rounds,       type: Integer, default: 0

    # wait time left in the current round
    field :round_wt,     type: Integer, default: 0

    # maximum wait time in a round
    field :round_wt_max, type: Integer, default: 1000

    # total wait time in the current battle
    field :battle_wt,    type: Integer, default: 0
  end
end
