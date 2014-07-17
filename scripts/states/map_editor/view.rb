class MapEditorView < RenderContainer
  attr_accessor :notifications

  attr_reader :layer_view
  attr_reader :ui_posmon

  def initialize
    super

    @font = ES.cache.font "uni0553", 16

    @hud = RenderContainer.new

    @help_panel       = ES::UI::MapEditorHelpPanel.new

    @dashboard        = ES::UI::MapEditorDashboard.new
    @layer_view       = ES::UI::MapEditorLayerView.new
    @tile_info        = ES::UI::TileInfo.new
    @tile_panel       = ES::UI::TilePanel.new
    @tile_preview     = ES::UI::TilePreview.new

    @ui_posmon        = ES::UI::PositionMonitor.new
    @ui_camera_posmon = ES::UI::PositionMonitor.new

    @notifications    = ES::UI::Notifications.new

    @tileselection_rect = ES::UI::SelectionTileRect.new

    @cursor_ss  = ES.cache.block "e032x032.png", 32, 32
    @passage_ss = ES.cache.block "passage_blocks.png", 32, 32

    @tile_preview.tileset = @tileset

    @tile_info.map = @map
    @tile_info.tileset = @tileset

    @tile_panel.tileset = @tileset

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

    @ui_posmon.obj = @entity
    @ui_camera_posmon.obj = @camera

    create_passage_layer
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
    @map.chunks.each do |chunk|
      x, y, z = *map_pos_to_screen_pos(chunk.position)
      @font.render x, y-oy, z, chunk.name, color, outline: 0, transform: @transform
    end
  end

  def render_edit_mode
    #@cursor_ss.render(*(@cursor_position+[0, 0, 0]), 1, transform: @transform)
    #@tileselection_rect.render 0, 0, 0, transform: @transform if @tileselection_rect.active?
    #if @controller.mode.is? :show_chunk_labels
    #  render_chunk_labels
    #end
    @hud.render
  end
end
