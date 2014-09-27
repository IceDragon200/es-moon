class CharacterAttribute
  include Moon::Component
  register :character

  field :filename,    type: String,  default: ""
  field :index,       type: Integer, default: 0
  field :cell_width,  type: Integer, default: 0
  field :cell_height, type: Integer, default: 0
end
