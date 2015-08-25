require 'scripts/core/camera_cursor2'
require 'scripts/models/map'
require 'scripts/models/tile_palette'
require 'scripts/core/map_cursor'

class MapEditorModel < State::ModelBase
  array :layer_opacity,          type: Float,           default: proc{ [1.0, 1.0] }
  field :cam_cursor,             type: CameraCursor2,   default: proc{ |t| t.model.new }
  field :camera,                 type: Camera2,         default: nil
  field :camera_move_speed,      type: Moon::Vector2,   default: proc{ |t| t.model.new(8, 8) }
  field :enable_sounds,          type: Boolean,         default: false
  field :keyboard_only_mode,     type: Boolean,         default: false
  field :layer,                  type: Integer,         default: -1
  field :layer_count,            type: Integer,         default: 2
  field :map,                    type: ES::Map,         default: nil
  field :map_cursor,             type: MapCursor,       default: proc{ |t| t.model.new }
  field :selection_rect,         type: Moon::Rect,      default: proc{ |t| t.model.new(0, 0, 0, 0) }
  field :selection_stage,        type: Integer,         default: 0
  field :show_chunk_labels,      type: Boolean,         default: false
  field :show_grid,              type: Boolean,         default: false
  field :tile_palette,           type: ES::TilePalette, default: proc{ |t| t.model.new }
  field :zoom,                   type: Float,           default: 1.0

  def save
    data = @model.export
    data['camera'] = nil
    YAML.save_file('editor.yml', data)
  end
end
