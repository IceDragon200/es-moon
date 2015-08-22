module ES
  module UI
    class PositionMonitor < Moon::Label
      attr_accessor :obj

      def initialize
        super '', ES.game.font_cache.font('uni0553', 16)
        @obj = nil
      end

      def update(delta)
        if @obj
          o = @obj.position

          #set_string("x: #{o.x.round(2)}, y: #{o.y.round(2)}")
          self.string = "x: #{o.x.to_i}, y: #{o.y.to_i}"
        else
          self.string = 'x: -.-, y: -.-'
        end
      end
    end
  end
end
