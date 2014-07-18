require "scripts/states/map_editor/camera_cursor"
require "scripts/states/map_editor/map_cursor"

class MapEditorModel < ::DataModel::Metal
  field :map,             type: ES::DataModel::EditorMap, allow_nil: true, default: nil
  field :camera,          type: Camera2,        default: proc{Camera2.new}
  field :cam_cursor,      type: CameraCursor,   default: proc{CameraCursor.new}
  field :map_cursor,      type: MapCursor,      default: proc{MapCursor.new}
  field :selection_stage, type: Integer,        default: 0
  field :layer,           type: Integer,        default: 1
  field :layer_opacity,   type: [Float],        default: proc{[1.0, 1.0]}
  field :layer_count,     type: Integer,        default: 2
  field :zoom,            type: Float,          default: 1.0
  field :flag_show_chunk_labels, type: Boolean, default: false
  field :keyboard_only_mode, type: Boolean,     default: false

  def update(delta)
    @cam_cursor.update delta
    @camera.update delta
  end
end
