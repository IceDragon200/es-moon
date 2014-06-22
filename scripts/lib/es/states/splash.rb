module ES
  module States
    class Splash < Base

      def init
        super
        font = ES.cache.font "uni0553", 16
        @text = Text.new "Earthen : Smiths #{ES::Version::STRING}", font
        @moon_logo = Moon::Sprite.new("resources/splash/moon-logo.png")
        @moon_logo.ox = @moon_logo.width / 2
        @moon_logo.oy = @moon_logo.height / 2
        add_task 2 do
          State.pop
        end
      end

      def update(delta)
        #
        super delta
      end

      def render
        x = (Moon::Screen.width - @moon_logo.width) / 2
        y = (Moon::Screen.height - @moon_logo.height) / 2
        @moon_logo.render x, y, 0
        x = (Moon::Screen.width - @text.width) / 2
        y = (Moon::Screen.height - @text.height) / 2
        @text.render(x, y, 0)
        super
      end

    end
  end
end
