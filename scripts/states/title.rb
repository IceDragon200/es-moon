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
      @background = Moon::Sprite.new(tex).to_sprite_context
      @background.sprite.opacity = 0.0

      @gui.add @background
    end

    def create_title_menu
      @title_menu = UI::TitleMenu.new
      @title_menu.tag('#menu')
      @title_menu.align!('center', screen.rect)
      #@title_menu.position = Moon::Vector3.new(8, 4, 0)

      # temp, until events are seperate components
      #@title_menu.enable_default_events
      @title_menu.elements.each_with_index do |elm, i|
        elm.enable_default_events
        elm.on :click do |e|
          @title_menu.index = i
        end

        elm.on :double_click do
          @title_menu.index = i
          on_title_menu_accept
        end
      end

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
        state_manager.push States::EsMapEditor
      when :quit
        state_manager.pop
      end
    end
  end
end
