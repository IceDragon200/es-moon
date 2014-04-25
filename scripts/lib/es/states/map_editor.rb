module ES
  module States
    class MapEditor < Map

      def init
        super
        @mouse = Moon::Input::Mouse

        @cursor_position = Vector3.new
        @cursor_position_map_pos = Vector3.new

        @tile_panel_visible = false

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
        @help_visible = false

        @cursor_ss = Moon::Spritesheet.new("resources/blocks/e032x032.png", 32, 32)
        @layer_ss = Moon::Spritesheet.new("resources/blocks/b016x016.png", 16, 16)
        @passage_ss = Moon::Spritesheet.new("resources/blocks/passage_blocks.png", 32, 32)

        create_passage_layer

        @layer_opacity = [1.0, 1.0]
        @layer_count = 2

        @tilemaps.each { |t| t.layer_opacity = @layer_opacity }

        @mode = :view
        @layer = -1

        register_events
      end

      def create_passage_layer
        @passage_tilemap = Tilemap.new do |tilemap|
          tilemap.position.set(0, 0, 0)
          tilemap.tileset = @passage_ss
          tilemap.data = @passage_data # special case passage data
        end
      end

      def register_events
        ## help
        @input.on :press, Moon::Input::F1 do
          @help_visible = true
        end
        @input.on :release, Moon::Input::F1 do
          @help_visible = false
        end
        ## tile panel
        @input.on :press, Moon::Input::TAB do
          @tile_panel_visible = true if @mode == :edit
        end
        @input.on :release, Moon::Input::TAB do
          @tile_panel_visible = false if @mode == :edit
        end
        ## place tile
        @input.on :press, Moon::Input::MOUSE_LEFT do
          if @tile_panel_visible
            @tile_panel.select_tile(@mouse.pos-[0,8])
          else
            place_tile(@tile_panel.tile_id) if @mode == :edit
          end
        end
        ## copy tile
        @input.on :press, Moon::Input::MOUSE_MIDDLE do
          copy_tile if @mode == :edit
        end
        ## erase tile
        @input.on :press, Moon::Input::MOUSE_RIGHT do
          erase_tile if @mode == :edit
        end
        ## mode toggle
        @input.on :press, Moon::Input::E do
          @mode = :edit
        end
        @input.on :press, Moon::Input::V do
          @mode = :view
        end
        ## layer toggle
        setlayer = lambda do |layer|
          @layer = layer
          if @layer < 0
            @layer_opacity.map! { 1.0 }
          else
            @layer_opacity.map! { 0.3 }
            @layer_opacity[@layer] = 1.0
          end
        end
        @input.on :press, Moon::Input::N0 do
          setlayer.(-1)
        end
        @input.on :press, Moon::Input::N1 do
          setlayer.(0)
        end
        @input.on :press, Moon::Input::N2 do
          setlayer.(1)
        end
      end

      def update_map
        return if @help_visible
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
        if !@tile_panel_visible
          tp = screen_pos_to_map_pos(Vector3[@mouse.x, @mouse.y, 0])
          @cursor_position_map_pos = tp
          @tile_info.tile_position.set(@cursor_position_map_pos.xy)
        end

        @cursor_position.set(@cursor_position_map_pos.floor * 32 - @camera.view.floor)

        @tile_panel.update
        @tile_preview.tile_id = @tile_panel.tile_id
      end

      def update
        unless @help_visible
          update_edit_mode if @mode == :edit
        end
        super
      end

      def render_edit_mode
        @tile_info.render

        if @tile_panel_visible
          @tile_panel.render
        else
          @tile_preview.render
        end

        @layer_count.times do |i|
          @layer_ss.render @tile_preview.x + i * @layer_ss.cell_width,
                           @tile_preview.y2,
                           @tile_preview.z,
                           i == @layer ? 12 : 1
        end

        @layer_ss.render @tile_preview.x,
                         @tile_preview.y2 + @layer_ss.cell_height,
                         @tile_preview.z,
                         13

        @cursor_ss.render(*@cursor_position, 1)
      end

      def render
        if @help_visible
          @help_panel.render
        else
          super
          render_edit_mode if @mode == :edit
        end
      end

    end
  end
end