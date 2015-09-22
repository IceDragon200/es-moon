require 'scripts/models/tileset'
require 'scripts/renderers/grid_cursor_renderer'
require 'scripts/renderers/grid_renderer'
require 'scripts/ui/text_list'
require 'scripts/ui/notifications'
require 'scripts/ui/passage_editor'

module States
  # An editor state for modifying Tileset data, mostly their passage data
  class TilesetEditor < Base
    private def create_ui
      @tilesets_list = UI::TextList.new font: game.fonts['system']
      @tilesets.each do |tileset|
        @tilesets_list.add_entry :tileset, name: tileset.id, tileset: tileset, cb: -> { set_active_tileset tileset }
      end

      @passage_editor = UI::PassageEditor.new
      @passage_editor.position.set(screen.w - @passage_editor.w - 16, 16, 0)

      @notifications = ES::UI::Notifications.new
      @notifications.position.set(32, screen.h - @notifications.font.size * 2, 0)

      @save_button = Moon::Sprite.new(game.textures['ui/tileset_editor_save_button']).to_sprite_context
      @save_button.position.set(screen.w - @save_button.w - 16, screen.h - @save_button.h - 16, 0)

      @gui.add @tilesets_list
      @gui.add @passage_editor
      @gui.add @notifications
      @gui.add @save_button
    end

    private def create_tileset_grid
      @tileset_grid = ES::GridRenderer.new(texture: game.textures['ui/tileset_editor_grid'])
      @tileset_view.add @tileset_grid
    end

    private def create_tileset_sprite
      tsprite = Moon::Sprite.new(game.textures['placeholder/32x32'])
      @tileset_sprite = tsprite.to_sprite_context
      @tileset_view.add @tileset_sprite
    end

    private def create_grid_cursor
      @grid_cursor = Renderers::GridCursor.new texture: game.textures['ui/tileset_editor_cursor']
      @tileset_view.add @grid_cursor
    end

    private def create_tileset_view
      @tileset_view = Moon::RenderContainer.new
      @tileset_view.position.set(16, 16, 0)

      @gui.add @tileset_view

      create_tileset_grid
      create_tileset_sprite
      create_grid_cursor
    end

    private def build_tileset_list
      @tilesets = []
      game.database.each_pair do |_, model|
        @tilesets << model if model.is_a?(Models::Tileset)
      end
    end

    def start
      super
      build_tileset_list
      create_tileset_view
      create_ui

      # When the user makes changes in the tileset editor, the change is
      # emitted as an event, here we update the tilesets passage data
      @passage_editor.on :passage_changed do |e|
        @tileset.passages[@grid_cursor.index] = e.passage
      end

      # Clicking on the tileset image should change the tile index for editing
      @tileset_sprite.input.on :press do |e|
        if e.is_a?(Moon::MouseInputEvent) && e.button == :mouse_left
          if @tileset && @tileset_sprite.contains_pos?(e.position)
            rel = @tileset_sprite.screen_to_relative(e.position)
            col = (rel.x / @tileset.cell_w).to_i
            row = (rel.y / @tileset.cell_h).to_i
            @grid_cursor.cols = (@tileset_sprite.texture.w / @tileset.cell_w).to_i
            @grid_cursor.index = col + row * @grid_cursor.cols

            @passage_editor.passage = @tileset.passages[@grid_cursor.index] || 0
          end
        end
      end

      # When you click on the Save Button, it should save the current tileset
      @save_button.input.on :press do |e|
        if e.is_a?(Moon::MouseInputEvent) && e.button == :mouse_left
          if @tileset && @save_button.contains_pos?(e.position)
            @tileset.save_file
            @notifications.notify "Saved #{@tileset.id}"
          end
        end
      end
    end

    def setup_tileset
      @tileset_sprite.texture = game.textures[@tileset.filename]
      @tileset_grid.bounds = [@tileset_sprite.texture.w, @tileset_sprite.texture.h]
    end

    def set_active_tileset(tileset)
      @tilesets_list.deactivate.hide
      @tileset = tileset
      setup_tileset
    end
  end
end
