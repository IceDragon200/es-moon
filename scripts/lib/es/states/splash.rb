module ES
  module States
    class Splash < State

      def init
        font = Cache.font "uni0553", 14
        @text = Text.new("Earthen : Smiths #{ES::Version::STRING}", font)
        @countdown = Countdown.new(120) # about 2 seconds
        super
      end

      def update
        #
        super
      end

      def render
        x = (Moon::Screen.width - @text.width) / 2
        y = (Moon::Screen.height - @text.height) / 2
        @text.render(x, y, 0)
        @countdown.update
        super
        State.pop if @countdown.done?
      end

    end
  end
end