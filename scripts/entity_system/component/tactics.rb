class TacticalComponent
  include Moon::EntitySystem::Component
  register :tactics

  field :subject,   field: String,  default: nil
  field :phase,     field: Integer, default: Enum::TacticsPhase::INVALID
  field :rounds,    field: Integer, default: 0
  field :round_wt,  field: Integer, default: 0
  field :battle_wt, field: Integer, default: 0
end
