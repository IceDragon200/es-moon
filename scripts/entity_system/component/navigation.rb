class NavigationComponent
  include Moon::EntitySystem::Component
  register :navigation

  field :destination, type: Moon::Vector3
end
