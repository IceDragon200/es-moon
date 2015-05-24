# communication interface between an entity and its renderer
class SpriteComponent
  include Moon::EntitySystem::Component
  register :sprite

  field :filename,  type: String
  field :clip_rect, type: Moon::Rect
  # last known rendered bounds
  field :bounds, type: Moon::Cuboid, default: proc { |t| t.model.new }
end
