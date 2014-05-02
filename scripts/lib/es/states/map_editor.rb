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

        @dashboard_visible = false

        @dashboard = ES::UI::MapEditorDashboard.new
        @dashboard.position.set 0, -@dashboard.height, 0

        @tile_preview = ES::UI::TilePreview.new
        @tile_preview.tileset = @tileset
        @tile_preview.position.set Moon::Screen.width - @tile_preview.width, 0, 0

        @tile_info = ES::UI::TileInfo.new
        @tile_info.map = @map
        @tile_info.tileset = @tileset
        @tile_info.position.set 0, 8, 0

        @tile_panel = ES::UI::TilePanel.new
        @tile_panel.tileset = @tileset
        @tile_panel.position.set 0, Moon::Screen.height - 32 * @tile_panel.visible_rows - 16, 0

        @help_panel = ES::UI::MapEditorHelpPanel.new


        @cursor_ss = Moon::Spritesheet.new("resources/blocks/e032x032.png", 32, 32)
        @layer_ss = Moon::Spritesheet.new("resources/blocks/b016x016.png", 16, 16)
        @passage_ss = Moon::Spritesheet.new("resources/blocks/passage_blocks.png", 32, 32)

        @tileselection_rect = ES::UI::SelectionTileRect.new
        @tileselection_rect.spritesheet = @cursor_ss
        @tileselection_rect.color.set 0.1059, 0.6314, 0.8863, 1.0000

        create_passage_layer

        create_debug_objects

        @ui_posmon.set_obj(@entity, true)
        @ui_camera_posmon.set_obj(@camera, true)

        @layer_opacity = [1.0, 1.0]
        @layer_count = 2

        @tilemaps.each { |t| t.layer_opacity = @layer_opacity }

        @mode = ModeStack.new
        @mode.push :view
        set_layer(-1)

        register_events
      end

      def create_passage_layer
        @passage_tilemap = Tilemap.new do |tilemap|
          tilemap.position.set(0, 0, 0)
          tilemap.tileset = @passage_ss
          tilemap.data = @passage_data # special case passage data
        end
      end

      def create_debug_objects
        @ui_posmon = ES::UI::PositionMonitor.new
        @ui_camera_posmon = ES::UI::PositionMonitor.new
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
        @input.on :press, Moon::Input::F2 do
          if @mode.is? :edit
            @mode.push :dashboard
            @dashboard.transition :position, Vector3[0, 0, 0]
          elsif @mode.is? :dashboard
            @mode.pop
            @dashboard.transition :position, Vector3[0, -@dashboard.height, 0]
          end
        end

        ## tile panel
        @input.on :press, Moon::Input::TAB do
          if @mode.is? :edit
            @mode.push :tile_select
          end
        end
        @input.on :release, Moon::Input::TAB do
          @mode.pop if @mode.is? :tile_select
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

      def update_map
        return if @mode.is? :help
        super
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

      def update_edit_mode
        if @mode.is? :edit
          tp = screen_pos_to_map_pos(Vector3[@mouse.x, @mouse.y, 0])
          @cursor_position_map_pos = tp
          @tile_info.tile_position.set(@cursor_position_map_pos.xy)
          @cursor_position.set(@cursor_position_map_pos.floor * 32 - @camera.view.floor)
        end

        @tile_panel.update
        @dashboard.update
        @tile_preview.tile_id = @tile_panel.tile_id
      end

      def update
        if @mode.has? :edit
          update_edit_mode
        end

        @ui_posmon.update
        @ui_camera_posmon.update
        super
      end

      def render_edit_mode
        ox = 0
        oy = @dashboard.y2
        @dashboard.render ox, 0, 0
        @tile_info.render ox, oy, 0

        if @mode.is? :tile_select
          @tile_panel.render ox, oy, 0
        else
          @tile_preview.render ox, oy, 0
          @layer_count.times do |i|
            @layer_ss.render @tile_preview.x + i * @layer_ss.cell_width + ox,
                             @tile_preview.y2 + oy,
                             @tile_preview.z,
                             i == @layer ? 12 : 1
          end

          @layer_ss.render @tile_preview.x + ox,
                           @tile_preview.y2 + @layer_ss.cell_height + oy,
                           @tile_preview.z,
                           13
        end


        @cursor_ss.render(*(@cursor_position+[0, 0, 0]), 1)

        h = Moon::Screen.height - @ui_posmon.height
        @ui_posmon.render((Moon::Screen.width - @ui_posmon.width) / 2 + ox, h + oy, 0)
        @ui_camera_posmon.render((Moon::Screen.width - @ui_camera_posmon.width) / 2 + ox,
                                  Moon::Screen.height - @ui_camera_posmon.height - h + oy,
                                  0)
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