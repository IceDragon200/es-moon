module ES
  module GData
    class Entity

      attr_accessor :position
      attr_accessor :dest_position

      def initialize
        moveto(0, 0, 0)
      end

      def move_speed
        0.08
      end

      def moveto(x, y, z=nil)
        @position = Vector3[x, y, z || (@position && @position.z) || 0]
        @dest_position = @position.dup
      end

      def move(x, y, z=0)
        @dest_position = @position + Vector3[x, y, z] * move_speed
      end

      def moving?
        @dest_position != @position
      end

      def update
        #
      end

    end
  end
end