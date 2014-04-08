module ES
  module States
    class Title < State

      def init
        super
        @title_menu = ES::UI::TitleMenu.new
      end

      def update
        #
        super
      end

      def render
        @title_menu.render(0, 0, 0)
        super
      end

    end
  end
end