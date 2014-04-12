module ES
  module GData
    class Map

      attr_reader :size

      def initialize
        reset
      end

      def reset
        @dmap = nil
        @chunks = nil
        @entities = nil
        @size = nil
        @passages = nil
      end

      def setup(dmap)
        reset
        @dmap = dmap
        @chunks = @dmap.chunks.map do |dchunk_lookup|
          dchunk = Database.find :chunk, dchunk_lookup
          chunk = ES::GData::Chunk.new
          chunk.setup(dchunk)
          chunk
        end
        refresh_chunk_positions
        refresh_size
        refresh_passages
      end

      def refresh_chunk_positions
        @chunks.each_with_index do |chunk, i|
          chunk.position.set(*@dmap.chunk_position[i])
        end
      end

      def refresh_size
        @size = Vector3.new(0, 0, 0)
        @chunks.each do |chunk|
          x, y, z = *(chunk.position + chunk.size)
          @size.x = x if @size.x < x
          @size.y = y if @size.y < y
          @size.z = z if @size.z < z
        end
      end

      def refresh_passages
        @passages = Table.new(@size.x, @size.y)
      end

    end
  end
end