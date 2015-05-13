class TeamComponent
  include Moon::EntitySystem::Component
  register :team

  field :number, type: Integer, default: 0
end
