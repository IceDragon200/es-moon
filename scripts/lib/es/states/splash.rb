module ES
  module States
    class Splash < State

      def init
        @bitmapfont = BitmapFont.new("media/bmpfont/font_cga8_white.png")
        @bitmapfont.string = "Earthen : Smiths #{ES::Version::STRING}"
        @countdown = Countdown.new(120) # about 2 seconds
        super
      end

      def update
        #
        super
      end

      def render
        x = (Moon::Screen.width - @bitmapfont.width) / 2
        y = (Moon::Screen.height - @bitmapfont.height) / 2
        @bitmapfont.render(x, y, 0)
        @countdown.update
        super
        State.pop if @countdown.done?
      end

    end
  end
end