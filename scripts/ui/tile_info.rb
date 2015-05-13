module ES
  module UI
    class TileInfo < Moon::RenderContext
      attr_accessor :tileset       # Spritesheet
      attr_accessor :tile_data     # DataModel::TileData

      def initialize
        super
        @tile_data = nil
        @tileset = nil # spritesheet
        @text = Moon::Text.new '', FontCache.font('uni0553', 16)

        texture = TextureCache.block 'e008x008.png'
        @block_ss = Moon::Spritesheet.new(texture, 8, 8)
      end

      def render_content(x, y, z, options)
        return unless @tile_data

        tile_ids = @tile_data[:tile_ids] || []
        chunk = @tile_data[:chunk]
        passage = @tile_data[:passage]

        data_position = @tile_data[:data_position]

        chunk_id = chunk ? chunk.id : ''
        chunk_name = chunk ? chunk.name : ''
        chunk_uri = chunk ? chunk.uri : ''
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

        @text.render x, y, z
        y += @text.h


        # draw blocks for passage
        if passage == ES::Passage::NONE
          @block_ss.render x + @block_ss.cell_w,
                           y + @block_ss.cell_h,
                           z,
                           8
        else
          @block_ss.render x + @block_ss.cell_w,
                           y,
                           z,
                           passage.masked?(ES::Passage::UP) ? 9 : 8
          #
          @block_ss.render x,
                           y + @block_ss.cell_h,
                           z,
                           passage.masked?(ES::Passage::LEFT) ? 9 : 8
          #
          @block_ss.render x + @block_ss.cell_w,
                           y + @block_ss.cell_h,
                           z,
                           passage.masked?(ES::Passage::ABOVE) ? 12 : 1
          #
          @block_ss.render x + @block_ss.cell_w * 2,
                           y + @block_ss.cell_h,
                           z,
                           passage.masked?(ES::Passage::RIGHT) ? 9 : 8
          #
          @block_ss.render x + @block_ss.cell_w,
                           y + @block_ss.cell_h * 2,
                           z,
                           passage.masked?(ES::Passage::DOWN) ? 9 : 8
        end

        if @tileset
          y += @block_ss.cell_h * 3
          tile_ids.each_with_index do |tile_id, i|
            next if tile_id < 0
            xo = @tileset.cell_w * i


            @tileset.render x + xo, y, z, tile_id

            @text.string = tile_id.to_s
            @text.render x + xo, y + @tileset.cell_h, z
          end
        end
        super
      end
    end
  end
end
