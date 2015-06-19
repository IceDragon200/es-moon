require 'scripts/entity_system/component'

class TacticalComponent < ES::EntitySystem::Component
  register :tactics

  # whether the tactics is currently idling, this causes the tactics system to
  # skip the component for processing, ultimately halting the phase process.
  field :idle,         field: Boolean, default: false
  # current acting entity's ID
  field :subject_id,   field: String,  default: nil
  # current phase
  field :phase,        field: Integer, default: Enum::TacticsPhase::INVALID
  # next phase to goto
  field :next_phase,   field: Integer, default: Enum::TacticsPhase::INVALID
  # rounds passed so far in the current battle
  field :rounds,       field: Integer, default: 0
  # wait time left in the current round
  field :round_wt,     field: Integer, default: 0
  # maximum wait time in a round
  field :round_wt_max, field: Integer, default: 1000
  # total wait time in the current battle
  field :battle_wt,    field: Integer, default: 0
end
