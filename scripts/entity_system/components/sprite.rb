require 'scripts/entity_system/component'

# communication interface between an entity and its renderer
class SpriteComponent < ES::EntitySystem::Component
  register :sprite

  # sprite filename
  field :filename,  type: String
  # clip rect
  field :clip_rect, type: Moon::Rect, default: nil
  # last known rendered bounds
  field :bounds, type: Moon::Cuboid, default: proc { |t| t.model.new }
  # whether to draw the cursor around the sprite
  field :selected, type: Boolean, default: false
end
