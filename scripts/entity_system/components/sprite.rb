require 'scripts/entity_system/component'

module Components
  # communication interface between an entity and its renderer
  class Sprite < Base
    register :sprite

    attr_accessor :vbo
    attr_accessor :texture
    attr_accessor :material
    attr_accessor :last_clip_rect
    attr_accessor :last_material_id
    attr_accessor :last_type

    field :index,     type: Integer, default: 0

    # texture filename
    field :filename,  type: String
    field :material_id, type: String, default: 'sprite'
    # last known rendered bounds
    field :bounds,    type: Moon::Cuboid, default: proc { |t| t.model.new }

    field :type, type: String, default: 'sprite'

    # if type == SPRITESHEET
    field :cell_w, type: Integer, default: 0
    field :cell_h, type: Integer, default: 0

    # if type == SPRITE
    # clip rect
    field :clip_rect, type: Moon::Rect,   default: nil

    def vertex_index
      return index * 4 if type == 'spritesheet'
      index
    end
  end
end
