module ES
  module GameObject
    class Chunk

      attr_reader :dchunk

      attr_reader :size
      attr_accessor :position

      def initialize
        @dchunk = nil
        @position = nil
      end

      def setup(dchunk, position=[0,0,0])
        @dchunk = dchunk
        @position = Vector3.new(*position)
        refresh_size
      end

      def refresh_size
        @size = Vector3.new(*@dchunk.data.size)
      end

      def id
        @dchunk.id
      end

      def name
        @dchunk.name
      end

      def data
        @dchunk.data
      end

      def flags
        @dchunk.flags
      end

      def passages
        @dchunk.passages
      end

    end
  end
end