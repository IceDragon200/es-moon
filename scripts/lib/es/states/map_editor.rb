module ES
  module States
    class MapEditor < Map

      def init
        super
        @mouse = Moon::Input::Mouse

        @cursor_position = Vector2.new
        @cursor_position_map_pos = Vector2.new

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

        register_events
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
          @tile_panel_visible = true
        end
        @input.on :release, Moon::Input::TAB do
          @tile_panel_visible = false
        end
        ## place tile
        @input.on :press, Moon::Input::MOUSE_LEFT do
          if @tile_panel_visible
            @tile_panel.select_tile(@mouse.pos-[0,8])
          else
            place_tile
          end
        end
        ## copy tile
        @input.on :press, Moon::Input::MOUSE_MIDDLE do
          copy_tile
        end
        ## erase tile
        @input.on :press, Moon::Input::MOUSE_RIGHT do
          erase_tile
        end
      end

      def update_map
        return if @help_visible
        super
      end

      def place_tile
        info = @tile_info.info
        if chunk = info[:chunk]
          dx, dy, dz = *info[:chunk_data_position]
          chunk.data[dx, dy, dz] = @tile_panel.tile_id
        end
      end

      def copy_tile
        data = @tile_info.info[:data]
        tile_id = data.reject { |n| n == -1 }.last || -1
        @tile_panel.tile_id = tile_id
      end

      def erase_tile
        info = @tile_info.info
        if chunk = info[:chunk]
          dx, dy, dz = *info[:chunk_data_position]
          chunk.data[dx, dy, dz] = -1
        end
      end

      def update
        unless @help_visible
          if !@tile_panel_visible
            tp = screen_pos_to_map_pos(Vector2[@mouse.x, @mouse.y])
            @cursor_position_map_pos = tp
            @tile_info.tile_position.set(tp)
          end

          @cursor_position.set(@cursor_position_map_pos.floor * 32 - @camera.view_xy.floor)

          @tile_panel.update
          @tile_preview.tile_id = @tile_panel.tile_id
        end
        super
      end

      def render
        if @help_visible
          @help_panel.render
        else
          super
          @tile_info.render
          if @tile_panel_visible
            @tile_panel.render
          else
            @tile_preview.render
          end

          @cursor_ss.render(*@cursor_position, 0, 1)
        end
      end

    end
  end
end