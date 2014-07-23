module ES
  module UI
    class TileInfo < RenderContainer

      attr_accessor :tileset       # Spritesheet
      attr_accessor :tile_data     # DataModel::TileData

      def initialize
        super
        @tile_data = nil
        @tileset = nil # spritesheet
        @text = Text.new "", ES.cache.font("uni0553", 16)

        @block_ss = ES.cache.block "e008x008.png", 8, 8
        #@block_ss = ES.cache.block "e016x016.png", 16, 16
      end

      def render(x=0, y=0, z=0)
        return unless @tile_data

        px = x + @position.x
        py = y + @position.y
        pz = z + @position.z

        tile_ids = @tile_data[:tile_ids] || []
        chunk = @tile_data[:chunk]
        passage = @tile_data[:passage]

        data_position = @tile_data[:data_position]

        chunk_id = chunk ? chunk.id : ""
        chunk_name = chunk ? chunk.name : ""
        chunk_uri = chunk ? chunk.uri : ""
        chunk_position = chunk ? chunk.position.to_a : [-1, -1]
        chunk_data_pos = @tile_data[:chunk_data_position] || [-1, -1]


        @text.string = "#{chunk_id[0,5]} -- #{chunk_name} (#{chunk_uri})"
        ## verbose
        #@text.string ="" +
        #              "position:       #{data_position.to_a}\n" +
        #              "chunk_id:       #{chunk_id}\n" +
        #              "chunk_name:     #{chunk_name}\n" +
        #              "chunk_uri:      #{chunk_uri}\n" +
        #              "chunk_data_pos: #{chunk_data_pos.to_a}\n" +
        #              "chunk_position: #{chunk_position.to_a}\n" +
        #              "passage:        #{passage}\n" +
        #              "" # placeholder

        @text.render px, py, pz
        py += @text.height


        # draw blocks for passage
        if passage == ES::Passage::NONE
          @block_ss.render px + @block_ss.cell_width,
                           py + @block_ss.cell_height,
                           pz,
                           8
        else
          @block_ss.render px + @block_ss.cell_width,
                           py,
                           pz,
                           passage.masked?(ES::Passage::UP) ? 9 : 8
          #
          @block_ss.render px,
                           py + @block_ss.cell_height,
                           pz,
                           passage.masked?(ES::Passage::LEFT) ? 9 : 8
          #
          @block_ss.render px + @block_ss.cell_width,
                           py + @block_ss.cell_height,
                           pz,
                           passage.masked?(ES::Passage::ABOVE) ? 12 : 1
          #
          @block_ss.render px + @block_ss.cell_width * 2,
                           py + @block_ss.cell_height,
                           pz,
                           passage.masked?(ES::Passage::RIGHT) ? 9 : 8
          #
          @block_ss.render px + @block_ss.cell_width,
                           py + @block_ss.cell_height * 2,
                           pz,
                           passage.masked?(ES::Passage::DOWN) ? 9 : 8
        end

        if @tileset
          py += @block_ss.cell_height * 3
          tile_ids.each_with_index do |tile_id, i|
            next if tile_id < 0
            xo = @tileset.cell_width * i


            @tileset.render px + xo, py, pz, tile_id

            @text.string = tile_id.to_s
            @text.render px + xo, py + @tileset.cell_height, pz
          end
        end
        super x, y, z
      end

    end
  end
end
