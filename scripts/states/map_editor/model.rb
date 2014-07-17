require "scripts/states/map_editor/camera_cursor"
require "scripts/states/map_editor/map_cursor"

class MapEditorModel
  attr_accessor :map
  attr_accessor :camera
  attr_accessor :cam_cursor
  attr_accessor :map_cursor
  attr_accessor :cursor_position

  attr_accessor :layer
  attr_accessor :layer_opacity
  attr_accessor :layer_count

  attr_accessor :zoom

  attr_accessor :flag_show_chunk_labels

  def initialize
    @map = nil
    @camera = Camera2.new
    @cam_cursor = CameraCursor.new
    @map_cursor = MapCursor.new

    @cursor_position = Vector3.new

    @layer = -1
    @layer_opacity = [1.0, 1.0]
    @layer_count = @layer_opacity.size

    @zoom = 1.0
    @flag_show_chunk_labels = false

    init
  end

  def init
    #
  end

  def update(delta)
    @cam_cursor.update delta
    @camera.update delta
  end
end
