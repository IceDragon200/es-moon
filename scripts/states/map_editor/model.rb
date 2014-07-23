require "scripts/states/map_editor/camera_cursor"
require "scripts/states/map_editor/map_cursor"

class MapEditorModel < StateModel
  field :map,               type: ES::DataModel::EditorMap, allow_nil: true, default: nil
  field :camera_move_speed, type: Vector3,        default: proc{|t|t.new(8,8,0)}
  field :camera,            type: Camera2,        default: proc{|t|t.new}
  field :cam_cursor,        type: CameraCursor,   default: proc{|t|t.new}
  field :map_cursor,        type: MapCursor,      default: proc{|t|t.new}
  field :selection_rect,    type: Rect,           default: proc{|t|t.new(0,0,0,0)}
  field :selection_stage,   type: Integer,        default: 0
  field :layer,             type: Integer,        default: 1
  field :layer_opacity,     type: [Float],        default: proc{[1.0, 1.0]}
  field :layer_count,       type: Integer,        default: 2
  field :zoom,              type: Float,          default: 1.0
  field :flag_show_chunk_labels, type: Boolean, default: false
  field :keyboard_only_mode,     type: Boolean, default: false
  field :tile_palette,    type: ES::DataModel::EditorTilePalette, default: proc{|t|t.new}

  def update(delta)
    @cam_cursor.update delta
    @camera.update delta
  end
end
