module ES
  module GameObject
    class Entity

      attr_accessor :position
      attr_accessor :velocity
      attr_reader :bounding_box

      def initialize
        @position = Vector3.new
        @velocity = Vector3.new
        @bounding_box = Moon::Rect.new(0, 0, 1, 1)
        moveto(0, 0, 0)
      end

      def move_speed
        0.08
      end

      def moveto(x, y, z=nil)
        @position.set(x, y, z || (@position && @position.z) || 0)
        @velocity.set(0, 0, 0)
      end

      def move(x, y, z=0)
        @velocity = Vector3[x, y, z] * move_speed
      end

      def moving?
        !@velocity.zero?
      end

      def update
        #
      end

    end
  end
end