module ES
  module UI
    class PositionMonitor < BitmapFont

      def initialize
        super "cga8.png"
        @obj = nil
      end

      def update
        if @obj
          o = @obj
          o = @obj.position if @obj_uses_internal_position

          #set_string("x: #{o.x.round(2)}, y: #{o.y.round(2)}")
          self.string = "x: #{o.x.to_i}, y: #{o.y.to_i}"
        else
          self.string = "x: -.-, y: -.-"
        end
      end

      def set_obj(obj, obj_uses_internal_position=false)
        @obj = obj
        @obj_uses_internal_position = obj_uses_internal_position
      end

    end
  end
end