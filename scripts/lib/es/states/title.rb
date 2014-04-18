module ES
  module States
    class Title < State

      def init
        super
        @title_menu = ES::UI::TitleMenu.new
        @device = Moon::Input::Keyboard
        @up     = InputHandle.new(@device, ES::Config.controls[:up])
        @down   = InputHandle.new(@device, ES::Config.controls[:down])
        @accept = InputHandle.new(@device, ES::Config.controls[:accept])
        @cancel = InputHandle.new(@device, ES::Config.controls[:cancel])
      end

      def update
        if @up.triggered?
          @title_menu.index -= 1
        elsif @down.triggered?
          @title_menu.index += 1
        end
        on_title_menu_accept if @accept.triggered?
        super
      end

      def render
        @title_menu.render(0, 0, 0)
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