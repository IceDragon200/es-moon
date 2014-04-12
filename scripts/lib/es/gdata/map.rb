module ES
  module GData
    class Map

      attr_reader :size
      attr_reader :passages
      attr_accessor :entities

      def initialize
        reset
      end

      def reset
        @dmap = nil
        @chunks = nil
        @entities = nil
        @size = nil
        @passages = nil
        @chunk_map = nil
      end

      def setup(dmap)
        reset

        @dmap = dmap
        @entities = []
        @chunks = @dmap.chunks.map do |dchunk_lookup|
          dchunk = Database.find :chunk, dchunk_lookup
          chunk = ES::GData::Chunk.new
          chunk.setup(dchunk)
          chunk
        end

        refresh_chunk_positions
        refresh_size
        refresh_chunk_map
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

      def refresh_chunk_map
        @chunk_map = Table.new(*@size.xy.ceil)
        @chunk_map.fill(-1)
        @chunks.each_with_index do |chunk, i|
          pos  = chunk.position.ceil
          size = chunk.size.ceil
          size.y.times do |y|
            size.x.times do |x|
              @chunk_map[pos.x + x, pos.y + y] = i
            end
          end
        end
      end

      def refresh_passages
        @passages = Table.new(*@size.xy.ceil)
        @passages.map_with_xy do |_, x, y|
          @chunks[@chunk_map[x, y]].passages[x, y]
        end
      end

      def visible_chunks
        # for now, we say all the chunks are visible
        # however lately only about 1 or 2 will be visible at anytime
        # NOTE that visible_chunks.size == number_of_tilemaps
        # so try to keep this value to 2 or so
        @chunks
      end

      def update
        collision_test = []
        @entities.each do |entity|
          entity.update
          collision_test << entity if entity.moving?
        end

        ##
        # resolve collisions and so forth
        collision_test.each do |entity|
          dest = entity.dest_position
          src = entity.position
          delta = dest - src
          ##
          # determine entry points
          left  = delta.x < 0
          right = delta.x > 0
          up    = delta.y < 0
          down  = delta.y > 0
          ##
          #src_x = left ? src.x.floor : (right ? src.x.ceil : src.x.round)
          #src_y =   up ? src.y.floor : ( down ? src.y.ceil : src.y.round)
          #dest_x = left ? dest.x.floor : (right ? dest.x.ceil : dest.x.round)
          #dest_y =   up ? dest.y.floor : ( down ? dest.y.ceil : dest.y.round)
          src_x = src.x.round
          src_y = src.y.round
          dest_x = dest.x.round
          dest_y = dest.y.round
          #src_flr = src.xy.floor
          #dest_flr = dest.xy.floor
          src_flr = Vector2[src_x, src_y]
          dest_flr = Vector2[dest_x, dest_y]
          ##
          src_flag = @passages[*src_flr]
          dest_flag = @passages[*dest_flr]

          # if we aren't going to be in the same tile, can we leave the current?
          if src_flr != dest_flr
            x, y = *src
            #x = left ? src_flr.x : (right ? x : x)
            #y = up ? src_flr.y : (down ? y : y)
            if (left && !src_flag.masked?(ES::Passage::LEFT)) ||
               (right && !src_flag.masked?(ES::Passage::RIGHT)) ||
               (up && !src_flag.masked?(ES::Passage::UP)) ||
               (down && !src_flag.masked?(ES::Passage::DOWN)) ||
               # can we enter the destination tile?
               (dest_flag == ES::Passage::NONE)
              next entity.moveto(x, y)
            end
          end

          # we can move freely around in a tile
          entity.moveto(*dest)
        end
      end

    end
  end
end