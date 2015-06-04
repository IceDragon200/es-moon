class TeamComponent
  include Moon::EntitySystem::Component
  register :team

  field :number, type: Integer, default: Enum::Team::NEUTRAL
end
