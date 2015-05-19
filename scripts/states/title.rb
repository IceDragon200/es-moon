module States
  class Title < Base
    def init
      super
      create_background
      create_title_menu
    end

    def start
      super
      t = TweenScheduler.new(scheduler)
      t.tween_obj @background.sprite, :opacity, to: 1.0, duration: '2s', easer: Moon::Easing::Linear
      scheduler.print_jobs
    end

    def create_background
      tex = TextureCache.background 'title.png'
      @background = Moon::Sprite.new(tex).to_proxy_sprite
      @background.sprite.opacity = 0.0

      @gui.add @background
    end

    def create_title_menu
      @title_menu = UI::TitleMenu.new
      @title_menu.tag('#menu')
      @title_menu.add_entry(:newgame, 'New Game')
      @title_menu.add_entry(:continue, 'Continue')
      @title_menu.add_entry(:map_viewer, 'Map Viewer')
      @title_menu.add_entry(:map_editor, 'Map Editor')
      @title_menu.add_entry(:quit, 'Quit')
      #
      @title_menu.align!('center', screen.rect)
      #@title_menu.position = Moon::Vector3.new(8, 4, 0)

      @gui.add @title_menu
    end

    def register_input
      input.on :press, :repeat do |e|
        case e.key
        when :up
          @title_menu.index -= 1
        when :down
          @title_menu.index += 1
        end
      end

      input.on :press do |e|
        if e.key == :enter || e.key == :z
          on_title_menu_accept
        end
      end
    end

    def on_title_menu_accept
      case @title_menu.current_item[:id]
      when :newgame
        state_manager.change States::NewGame
      when :map_viewer
        state_manager.push States::MapViewer
      when :map_editor
        state_manager.push EsMapEditor
      when :quit
        state_manager.pop
      end
    end
  end
end
