require 'scripts/entity_system/component'

class CharacterComponent < ES::EntitySystem::Component
  register :character

  field :filename,    type: String,  default: ''
  field :index,       type: Integer, default: 0
  field :cell_w,  type: Integer, default: 0
  field :cell_h, type: Integer, default: 0
end
