class MapEditorView < RenderContainer
  attr_accessor :notifications
  attr_accessor :model

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

  def initialize(model)
    @model = model
    super()

    @font = ES.cache.font "uni0553", 16

    @hud = RenderContainer.new

    @help_panel       = ES::UI::MapEditorHelpPanel.new(ES.cache.controlmap("map_editor.yml"))
    rect = LayoutHelper.align("center", @help_panel.to_rect, Screen.rect)
    @help_panel.position.set(rect.xyz)

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

    color = Vector4.new 0.1059, 0.6314, 0.8863, 1.0000
    color += color
    @tileselection_rect.spritesheet = @cursor_ss
    @tileselection_rect.color.set color

    @notifications.font = @font

    @dashboard.position.set 0, 0, 0
    @tile_info.position.set 0, @dashboard.y2 + 16, 0
    @tile_preview.position.set Screen.width - @tile_preview.width, @dashboard.y2, 0
    @tile_panel.position.set 0, Screen.height - 32 * @tile_panel.visible_rows - 16, 0
    @layer_view.position.set @tile_preview.x, @tile_preview.y2, 0
    @notifications.position.set @font.size, Screen.height - @font.size*2, 0

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
    color = Vector4::WHITE
    oy = @font.size
    @model.map.chunks.each do |chunk|
      x, y, z = *map_pos_to_screen_pos(chunk.position)
      @font.render x, y-oy, z, chunk.name, color, outline: 0
    end
  end

  def render_edit_mode
    @map_cursor.render(*@model.map_cursor.position*32-@model.camera.view.floor)#, transform: @transform)
    @tileselection_rect.render 0, 0, 0, transform: @transform if @tileselection_rect.active?
    render_chunk_labels if @model.flag_show_chunk_labels
    @hud.render
  end

  def render_help_mode
    @help_panel.render
  end

  def update(delta)
    super(delta)
    @dashboard.update(delta)
  end
end
