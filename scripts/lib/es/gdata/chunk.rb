module ES
  module GData
    class Chunk

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