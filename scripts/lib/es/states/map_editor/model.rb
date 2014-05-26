require "scripts/lib/es/states/map_editor/cam_cursor"

class MapEditorModel

  attr_accessor :cam_cursor
  attr_accessor :cursor_position
  attr_accessor :cursor_position_map_pos

  attr_accessor :layer
  attr_accessor :layer_opacity
  attr_accessor :layer_count

  attr_accessor :zoom

  def initialize
    @cam_cursor = CamCursor.new

    @cursor_position = Vector3.new
    @cursor_position_map_pos = Vector3.new

    @layer = -1
    @layer_opacity = [1.0, 1.0]
    @layer_count = @layer_opacity.size

    @zoom = 1.0
    init
  end

  def init

  end

end