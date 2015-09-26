require 'scripts/ui/dashboard'
require 'scripts/ui/help_panel'
require 'scripts/ui/layer_view'
require 'scripts/ui/map_list'
require 'scripts/ui/notifications'
require 'scripts/ui/position_monitor'
require 'scripts/ui/tile_info'
require 'scripts/ui/tile_panel'
require 'scripts/ui/tile_preview'

class MapEditorGuiView < State::ViewBase
  attr_accessor :notifications

  attr_reader :tileset

  attr_reader :hud

  attr_reader :dashboard
  attr_reader :help_panel
  attr_reader :layer_view
  attr_reader :map_list
  attr_reader :tile_info
  attr_reader :tile_panel
  attr_reader :tile_preview
  attr_reader :tileselection_rect
  attr_reader :ui_camera_posmon
  attr_reader :ui_posmon

  def initialize_view
    super
    @font = game.fonts['system.16']
    @controlmap = game.database['controlmaps/map_editor']

    @hud = Moon::RenderContainer.new

    @help_panel       = UI::MapEditorHelpPanel.new(@controlmap)

    @dashboard        = UI::MapEditorDashboard.new
    @layer_view       = UI::MapEditorLayerView.new
    @tile_info        = UI::TileInfo.new
    @tile_panel       = UI::TilePanel.new
    @tile_preview     = UI::TilePreview.new
    @map_list         = UI::MapList.new font: @font

    @ui_posmon        = UI::PositionMonitor.new
    @ui_camera_posmon = UI::PositionMonitor.new

    @notifications    = UI::Notifications.new
    @notifications.formatter = lambda do |s|
      t = Time.now
      "[#{t.hour}:#{t.min}] " << s
    end

    @passage_ss = Game.instance.spritesheets['ui/passage_blocks', 32, 32]

    @notifications.font = @font

    refresh_position

    @dashboard.show
    @tile_panel.hide
    @help_panel.hide
    @map_list.hide.deactivate

    @hud.add @dashboard
    @hud.add @layer_view
    @hud.add @tile_info
    @hud.add @tile_panel
    @hud.add @tile_preview
    @hud.add @ui_camera_posmon
    @hud.add @ui_posmon
    @hud.add @notifications
    @hud.add @help_panel
    @hud.add @map_list

    add @hud
  end

  def refresh_position
    @help_panel.position.set(@help_panel.to_rect.align('center', @view).position, 0)
    @dashboard.position.set @view.x, @view.y, 0
    @tile_info.position.set @view.x, @dashboard.y2 + 24, 0
    @tile_preview.position.set @view.x2 - @tile_preview.w, @dashboard.y2, 0
    @tile_panel.position.set @view.x, @view.y2 - 32 * @tile_panel.visible_rows - 64, 0
    @layer_view.position.set @tile_preview.x, @tile_preview.y2, 0
    @notifications.position.set @font.size, @view.y2 - @font.size*2, 0
    @ui_posmon.position.set @view.x2 - @ui_posmon.w - 96, @view.y, 0
    @ui_camera_posmon.position.set (@view.w - @ui_camera_posmon.w) / 2,
                                    @view.y2 - @font.size,
                                    0
    @map_list.position.set(32, @dashboard.y2 + 64, 0)
  end

  def spritesheet=(spritesheet)
    @spritesheet = spritesheet
    @tile_preview.spritesheet = @spritesheet
    @tile_info.spritesheet = @spritesheet
  end

  def tileset=(tileset)
    @tileset = tileset
    @tile_panel.tileset = @tileset
    self.spritesheet = Game.instance.spritesheets[@tileset.spritesheet_id]
  end
end
