module ES
  module GData
    class Character

      attr_accessor :position

      def initialize
        @position = Vector3.new(0, 0, 0)
      end

      def move_speed
        0.1
      end

      def move_xy(x, y)
        @position.xy += Vector2[x, y] * move_speed
      end

      def world_update
        #
      end

    end
  end
end