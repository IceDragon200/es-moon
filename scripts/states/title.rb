module ES
  module States
    class Title < Base
      def init
        super
        @title_menu = ES::UI::TitleMenu.new
        @title_sprite = ES.cache.system "title_text.png"
        register_events
      end

      def register_events
        @input.on :press, *ES::Config.controls[:up] do
          @title_menu.index -= 1
        end
        @input.on :press, *ES::Config.controls[:down] do
          @title_menu.index += 1
        end
        @input.on :press, *ES::Config.controls[:accept] do
          on_title_menu_accept
        end
        #@input.on :press, *ES::Config.controls[:cancel] do
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
