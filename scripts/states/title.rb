module States
  class Title < Base
    def init
      super
      create_title_menu

      #@title_texture = TextureCache.system "title_text.png"
      #@title_sprite = Moon::Sprite.new(@title_texture)

      register_events
    end

    def create_title_menu
      @title_menu = UI::TitleMenu.new
      @title_menu.add_entry(:newgame, "New Game")
      @title_menu.add_entry(:continue, "Continue")
      @title_menu.add_entry(:map_viewer, "Map Viewer")
      @title_menu.add_entry(:map_editor, "Map Editor")
      @title_menu.add_entry(:quit, "Quit")
      #
      @title_menu.align!("center", Moon::Screen.rect)
      @title_menu.position = Moon::Vector3.new(8, 4, 0)

      @gui.add @title_menu
    end

    def register_events
      @input.on :press, :up do
        @title_menu.index -= 1
      end

      @input.on :press, :down do
        @title_menu.index += 1
      end

      @input.on :press, :enter, :z do
        on_title_menu_accept
      end

      #@input.on :press, :x do
      #end
    end

    def on_title_menu_accept
      case @title_menu.current_item[:id]
      when :newgame
        State.change States::Map
      when :map_viewer
        State.change States::MapViewer
      when :map_editor
        State.change EsMapEditor
      when :quit
        State.pop
      end
    end
  end
end
