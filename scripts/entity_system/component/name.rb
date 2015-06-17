class NameComponent
  include Moon::EntitySystem::Component
  register :name

  field :string, field: String, default: 'Anonymous'
end
