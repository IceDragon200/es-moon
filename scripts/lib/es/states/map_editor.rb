module ES
  module States
    class MapEditor < Map

      def init
        super
        @mouse = Moon::Input::Mouse
        @keyboard = Moon::Input::Keyboard

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
      end

      def update_map
        return if @help_visible
        super
      end

      def update
        if @keyboard.triggered?(@keyboard::Keys::F1)
          @help_visible = !@help_visible
        end

        unless @help_visible
          if @keyboard.triggered?(@keyboard::Keys::TAB)
            @tile_panel_visible = !@tile_panel_visible
          end

          if !@tile_panel_visible
            tp = screen_pos_to_map_pos(Vector2[@mouse.x, @mouse.y])
            @cursor_position_map_pos = tp
            @tile_info.tile_position.set(tp)
            if @mouse.triggered?(@mouse::Buttons::BUTTON_2)
              data = @tile_info.info[:data]
              tile_id = data.reject { |n| n == -1 }.last
              @tile_panel.tile_id = tile_id
            end
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