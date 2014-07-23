module ES
  module States
    class Title < Base
      def init
        super
        @title_menu = ES::UI::TitleMenu.new
        @title_sprite = ES.cache.system "title_text.png"

        @title_menu.position.set(8, 4, 0)

        register_events
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

      def update(delta)
        super delta
      end

      def render
        @title_menu.render 0, 0, 0
        @title_sprite.render Screen.width - @title_sprite.width,
                             Screen.height - @title_sprite.height,
                             0
        super
      end

      def on_title_menu_accept
        case @title_menu.current_item[:id]
        when :newgame
          State.change(ES::States::MapEditor)
        when :quit
          State.pop
        end
      end
    end
  end
end
