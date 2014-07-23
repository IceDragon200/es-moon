class MapEditorView < StateView
  attr_accessor :notifications
  attr_reader :screen_rect

  attr_reader :tileset

  attr_reader :dashboard
  attr_reader :hud
  attr_reader :layer_view
  attr_reader :tile_info
  attr_reader :tile_panel
  attr_reader :tile_preview
  attr_reader :tileselection_rect
  attr_reader :ui_camera_posmon
  attr_reader :ui_posmon

  def init_view
    @screen_rect = Screen.rect.contract(16)

    @palette = ES.cache.palette
    @font = ES.cache.font "uni0553", 16
    @controlmap = ES.cache.controlmap("map_editor.yml")

    @hud = RenderContainer.new

    @help_panel       = ES::UI::MapEditorHelpPanel.new(@controlmap)
    @help_panel.position.set(@help_panel.to_rect.align("center", @screen_rect).xyz)

    @dashboard        = ES::UI::MapEditorDashboard.new
    @layer_view       = ES::UI::MapEditorLayerView.new
    @tile_info        = ES::UI::TileInfo.new
    @tile_panel       = ES::UI::TilePanel.new
    @tile_preview     = ES::UI::TilePreview.new

    @ui_posmon        = ES::UI::PositionMonitor.new
    @ui_camera_posmon = ES::UI::PositionMonitor.new

    @notifications    = ES::UI::Notifications.new

    @tileselection_rect = ES::UI::SelectionTileRect.new

    @map_cursor = Sprite.new("media/ui/map_editor_cursor.png")
    @cursor_ss  = ES.cache.block "e032x032.png", 32, 32
    @passage_ss = ES.cache.block "passage_blocks.png", 32, 32

    color = @palette["system/info"]
    color += color
    @tileselection_rect.spritesheet = @cursor_ss
    @tileselection_rect.color = color

    @notifications.font = @font

    refresh_position

    @dashboard.show
    @tile_panel.hide

    @hud.add @dashboard
    @hud.add @layer_view
    @hud.add @tile_info
    @hud.add @tile_panel
    @hud.add @tile_preview
    @hud.add @ui_camera_posmon
    @hud.add @ui_posmon
    @hud.add @notifications

    create_passage_layer
  end

  def refresh_position
    @dashboard.position.set @screen_rect.x, @screen_rect.y, 0
    @tile_info.position.set @screen_rect.x, @dashboard.y2 + 16, 0
    @tile_preview.position.set @screen_rect.x2 - @tile_preview.width, @dashboard.y2, 0
    @tile_panel.position.set @screen_rect.x, @screen_rect.y2 - 32 * @tile_panel.visible_rows - 16, 0
    @layer_view.position.set @tile_preview.x, @tile_preview.y2, 0
    @notifications.position.set @font.size, @screen_rect.y2 - @font.size*2, 0
    @ui_posmon.position.set @screen_rect.x2 - @ui_posmon.width - 96, @screen_rect.y, 0
    @ui_camera_posmon.position.set (@screen_rect.width - @ui_camera_posmon.width) / 2,
                                    @screen_rect.y2 - @font.size,
                                    0
  end

  ###
  # @param [Vector3] screen_pos
  ###
  def screen_pos_to_map_pos(screen_pos)
    (screen_pos + @model.camera.view.floor) / 32
  end

  def map_pos_to_screen_pos(map_pos)
    map_pos * 32 - @model.camera.view.floor
  end

  def screen_pos_map_reduce(screen_pos)
    screen_pos_to_map_pos(screen_pos).floor * 32 - @model.camera.view.floor
  end

  def tileset=(tileset)
    @tileset = tileset
    @tile_preview.tileset = @tileset
    @tile_info.tileset = @tileset
    @tile_panel.tileset = @tileset
  end

  def create_passage_layer
    @passage_tilemap = Tilemap.new do |tilemap|
      tilemap.position.set 0, 0, 0
      tilemap.tileset = @passage_ss
      tilemap.data = @passage_data # special case passage data
    end
  end

  def render_chunk_labels
    color = @palette["white"]
    oy = @font.size+8
    @model.map.chunks.each do |chunk|
      x, y, z = *map_pos_to_screen_pos(chunk.position)
      @font.render x, y-oy, z, chunk.name, color, outline: 0
    end
  end

  def render_edit_mode
    campos = @model.camera.view.floor
    @map_cursor.render(*@model.map_cursor.position*32-campos)

    if @model.selection_stage > 0
      @tileselection_rect.render(*(-campos))
    end

    render_chunk_labels if @model.flag_show_chunk_labels
    @hud.render
  end

  def render_help_mode
    @help_panel.render
  end

  def update_view(delta)
    @hud.update(delta)
    @dashboard.update(delta)
    super(delta)
  end
end
