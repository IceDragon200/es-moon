class CharacterComponent
  include Moon::EntitySystem::Component
  register :character

  field :filename,    type: String,  default: ''
  field :index,       type: Integer, default: 0
  field :cell_w,  type: Integer, default: 0
  field :cell_h, type: Integer, default: 0
end
