module ES
  module States
    class MapEditor < Map

      class ModeStack

        def initialize
          @list = []
        end

        def current
          @list[-1]
        end

        def push(mode)
          @list.push mode
          puts @list
        end

        def change(mode)
          @list[-1] = mode
          puts @list
        end

        def pop
          @list.pop
          puts @list
        end

        def is?(mode)
          current == mode
        end

        def has?(mode)
          @list.include?(mode)
        end

      end

      def init
        super
        @mouse = Moon::Input::Mouse

        @cursor_position = Vector3.new
        @cursor_position_map_pos = Vector3.new

        @hud = RenderLayer.new

        @help_panel       = ES::UI::MapEditorHelpPanel.new

        @dashboard        = ES::UI::MapEditorDashboard.new
        @layer_view       = ES::UI::MapEditorLayerView.new
        @tile_info        = ES::UI::TileInfo.new
        @tile_panel       = ES::UI::TilePanel.new
        @tile_preview     = ES::UI::TilePreview.new

        @ui_posmon        = ES::UI::PositionMonitor.new
        @ui_camera_posmon = ES::UI::PositionMonitor.new

        @tileselection_rect = ES::UI::SelectionTileRect.new

        @cursor_ss  = Cache.block "e032x032.png", 32, 32
        @passage_ss = Cache.block "passage_blocks.png", 32, 32

        @tile_preview.tileset = @tileset

        @tile_info.map = @map
        @tile_info.tileset = @tileset

        @tile_panel.tileset = @tileset

        @tileselection_rect.spritesheet = @cursor_ss
        @tileselection_rect.color.set 0.1059, 0.6314, 0.8863, 1.0000

        @dashboard.position.set 0, 0, 0
        @tile_info.position.set 0, @dashboard.y2 + 16, 0
        @tile_preview.position.set Screen.width - @tile_preview.width, @dashboard.y2, 0
        @tile_panel.position.set 0, Screen.height - 32 * @tile_panel.visible_rows - 16, 0

        @dashboard.show
        @tile_panel.hide

        @hud.add @dashboard
        @hud.add @layer_view
        @hud.add @tile_info
        @hud.add @tile_panel
        @hud.add @tile_preview
        @hud.add @ui_camera_posmon
        @hud.add @ui_posmon


        create_passage_layer

        @ui_posmon.obj = @entity
        @ui_camera_posmon.obj = @camera

        @layer_opacity = [1.0, 1.0]
        @layer_count = @layer_opacity.size

        @tilemaps.each { |t| t.layer_opacity = @layer_opacity }

        @mode = ModeStack.new
        @mode.push :view

        set_layer(-1)

        register_events
      end

      def create_passage_layer
        @passage_tilemap = Tilemap.new do |tilemap|
          tilemap.position.set 0, 0, 0
          tilemap.tileset = @passage_ss
          tilemap.data = @passage_data # special case passage data
        end
      end

      def set_layer(layer)
        @layer = layer
        if @layer < 0
          @layer_opacity.map! { 1.0 }
        else
          @layer_opacity.map! { 0.3 }
          @layer_opacity[@layer] = 1.0
        end
      end

      def register_events
        ## help
        @input.on :press, Moon::Input::F1 do
          @mode.push :help
        end
        @input.on :release, Moon::Input::F1 do
          @mode.pop
        end

        ## Dashboard
        #@input.on :press, Moon::Input::F2 do
        #  if @mode.is? :edit
        #    @mode.push :dashboard
        #  elsif @mode.is? :dashboard
        #    @mode.pop
        #  end
        #end

        ## tile panel
        @input.on :press, Moon::Input::TAB do
          if @mode.is? :edit
            @mode.push :tile_select
            @tile_panel.show
            @tile_preview.hide
          end
        end
        @input.on :release, Moon::Input::TAB do
          if @mode.is? :tile_select
            @mode.pop
            @tile_panel.hide
            @tile_preview.show
          end
        end

        ## multi function
        @input.on :press, Moon::Input::MOUSE_LEFT do
          ## interact
          if @mode.is? :dashboard
            pos = Moon::Input::Mouse.pos
            if @dashboard.pos_inside?(pos)
              @dashboard.trigger Input::MouseEvent.new(:click, pos)
            end
          ## select tile
          elsif @mode.is? :tile_select
            @tile_panel.select_tile(@mouse.pos-[0,16])
          ## place tile
          elsif @mode.is? :edit
            place_tile(@tile_panel.tile_id)
          end
        end

        ## copy tile
        @input.on :press, Moon::Input::MOUSE_MIDDLE do
          copy_tile if @mode.is? :edit
        end

        ## erase tile
        @input.on :press, Moon::Input::MOUSE_RIGHT do
          erase_tile if @mode.is? :edit
        end

        ## mode toggle
        @input.on :press, Moon::Input::E do
          @mode.change :edit
        end
        @input.on :press, Moon::Input::V do
          @mode.change :view
        end

        ## layer toggle
        @input.on :press, Moon::Input::N0 do
          set_layer(-1)
        end
        @input.on :press, Moon::Input::N1 do
          set_layer(0)
        end
        @input.on :press, Moon::Input::N2 do
          set_layer(1)
        end

      end

      def place_tile(tile_id)
        info = @tile_info.info
        if chunk = info[:chunk]
          dx, dy, _ = *info[:chunk_data_position]
          chunk.data[dx, dy, @layer] = tile_id
        end
      end

      def copy_tile
        data = @tile_info.info[:data]
        tile_id = data.reject { |n| n == -1 }.last || -1
        @tile_panel.tile_id = tile_id
      end

      def erase_tile
        place_tile(-1)
      end

      def update_edit_mode(delta)
        if @mode.is? :edit
          tp = screen_pos_to_map_pos(Vector3[@mouse.x, @mouse.y, 0])
          @cursor_position_map_pos = tp
          @tile_info.tile_position.set(@cursor_position_map_pos.xy)
          @cursor_position.set(@cursor_position_map_pos.floor * 32 - @camera.view.floor)
        end

        @hud.update delta
        @tile_preview.tile_id = @tile_panel.tile_id
      end

      def update_map(delta)
        return if @mode.is? :help
        super delta
      end

      def update(delta)
        if @mode.has? :edit
          update_edit_mode delta
        end

        h = Moon::Screen.height
        w = Moon::Screen.width
        @ui_posmon.position.set((w - @ui_posmon.width) / 2, 0, 0)
        @ui_camera_posmon.position.set((w - @ui_camera_posmon.width) / 2,
                                        h - @ui_camera_posmon.height,
                                        0)
        super delta
      end

      def render_edit_mode
        @cursor_ss.render(*(@cursor_position+[0, 0, 0]), 1)

        @hud.render
      end

      def render
        super
        if @mode.is? :help
          @help_panel.render
        elsif @mode.has? :edit
          render_edit_mode
        end
      end

    end
  end
end