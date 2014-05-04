module ES
  module GameObject
    class Map

      attr_reader :dmap # now, you don't usually expose this, but...
      attr_reader :size
      attr_reader :chunks
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
          chunk = ES::GameObject::Chunk.new
          chunk.setup(dchunk)
          chunk
        end

        refresh
      end

      def refresh
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
        @size = Vector3.new 0, 0, 0
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
          index = @chunk_map[x, y]
          next if index == -1
          chunk = @chunks[index]
          chunk.passages[x - chunk.position.x, y - chunk.position.y]
        end
      end

      def visible_chunks
        # for now, we say all the chunks are visible
        # however lately only about 1 or 2 will be visible at anytime
        # NOTE that visible_chunks.size == number_of_tilemaps
        # so try to keep this value to 2 or so
        @chunks
      end

      def update(delta)
        collision_test = []
        #interaction_test = []

        @entities.each do |entity|
          entity.update
          collision_test << entity if entity.moving?
          #interaction_test << entity if entity.interact?
        end

        ##
        # resolve collisions and so forth
        collision_test.each do |entity|
          velo = entity.velocity
          src = entity.position
          dest = src + velo
          chng = dest - src
          ##
          # determine entry points
          sig_x = chng.x <=> 0
          sig_y = chng.y <=> 0
          ##
          src_pos = src.xy.round
          sx, sy = *src_pos

          src_flag = @passages[*src_pos]

          dest_flag_x1y2 = @passages[sx, sy - 1]
          dest_flag_x1y3 = @passages[sx, sy + 1]
          dest_flag_x2y1 = @passages[sx - 1, sy]
          dest_flag_x3y1 = @passages[sx + 1, sy]
          dest_flag_x2y2 = @passages[sx - 1, sy - 1]
          dest_flag_x3y2 = @passages[sx + 1, sy - 1]
          dest_flag_x2y3 = @passages[sx - 1, sy + 1]
          dest_flag_x3y3 = @passages[sx + 1, sy + 1]

          bounds = Moon::Rect.new(0, 0, 0, 0)

          if src_flag.masked?(ES::Passage::LEFT)
            if dest_flag_x2y1 == ES::Passage::NONE
              bounds.x = sx
            else
              bounds.x = sx - 1
            end
          else
            bounds.x = sx
          end
          if src_flag.masked?(ES::Passage::RIGHT)
            if dest_flag_x3y1 == ES::Passage::NONE
              bounds.x2 = sx
            else
              bounds.x2 = sx + 1
            end
          else
            bounds.x2 = sx + 1
          end
          if src_flag.masked?(ES::Passage::UP)
            if dest_flag_x1y2 == ES::Passage::NONE
              bounds.y = sy
            else
              bounds.y = sy - 1
            end
          else
            bounds.y = sy
          end
          if src_flag.masked?(ES::Passage::DOWN)
            if dest_flag_x1y3 == ES::Passage::NONE
              bounds.y2 = sy
            else
              bounds.y2 = sy + 1
            end
          else
            bounds.y2 = sy + 1
          end

          entity.position.set([[dest.x, bounds.x].max, bounds.x2].min,
                              [[dest.y, bounds.y].max, bounds.y2].min,
                              entity.position.z)
        end
      end

      ###
      # Returns all the tiledata for this row
      ###
      def tile_data(x, y)
        data = {
          data_position: [x, y],
          passage: @passages[x, y] || 0,
        }
        chunk_index = @chunk_map[x, y]
        return data if chunk_index == -1

        chunk = @chunks[chunk_index]
        chunk_offset = chunk.position
        cx, cy = x - chunk.position.x, y - chunk.position.y

        data.merge chunk: chunk,
                   chunk_data_position: [cx, cy],
                   data: chunk.data.zsize.times.map { |z| chunk.data[cx, cy, z] }
      end

      def to_h
        {
          size: @size,
          chunks: @chunks,
          chunk_map: @chunk_map,
          passages: @passages,
          entities: @entities,
          dmap: @dmap,
        }
      end

    end
  end
end