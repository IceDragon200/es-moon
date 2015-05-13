module ES
  module UI
    class PositionMonitor < Moon::Text
      attr_accessor :visible
      attr_accessor :obj

      def initialize
        super '', FontCache.font('uni0553', 16)
        @visible = true
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
