module ES
  module UI
    class TilePreview < RenderContainer

      attr_accessor :map           # GameObject::Map
      attr_accessor :tile_position # Vector2
      attr_accessor :tileset       # Spritesheet

      def initialize
        super
        @map = nil
        @tile_position = Vector2.new(0, 0)
        @tileset = nil # spritesheet
        @bitmap_font = BitmapFont.new "font_cga8_white.png"

        @block_ss = Cache.block "e016x016.png", 16, 16
      end

      def render(x, y, z)
        if @map && @tileset
          px = x + @position.x
          py = y + @position.y
          pz = z + @position.z

          data = @map.tile_data(*@tile_position.floor)
          chunk = data[:chunk]
          passage = data[:passage]

          @bitmap_font.string = "" +
                                "position:       #{data[:data_position]}\n" +
                                "chunk_id:       #{chunk.id}\n" +
                                "chunk_name:     #{chunk.name}\n" +
                                "chunk_data_pos: #{data[:chunk_data_position]}\n" +
                                "chunk_position: #{chunk.position.to_a}\n" +
                                "" # placeholder
          @bitmap_font.render px, py, pz
          py += @bitmap_font.height

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

            @block_ss.render px,
                             py + @block_ss.cell_height,
                             pz,
                             passage.masked?(ES::Passage::LEFT) ? 9 : 8

            @block_ss.render px + @block_ss.cell_width,
                             py + @block_ss.cell_height,
                             pz,
                             passage.masked?(ES::Passage::ABOVE) ? 12 : 1

            @block_ss.render px + @block_ss.cell_width * 2,
                             py + @block_ss.cell_height,
                             pz,
                             passage.masked?(ES::Passage::RIGHT) ? 9 : 8

            @block_ss.render px + @block_ss.cell_width,
                             py + @block_ss.cell_height * 2,
                             pz,
                             passage.masked?(ES::Passage::DOWN) ? 9 : 8
          end

          py += @block_ss.cell_height * 3

          data[:data].each_with_index do |tile_id, i|
            next if tile_id < 0
            xo = @tileset.cell_width * i


            @tileset.render px + xo, py, pz, tile_id

            @bitmap_font.string = tile_id.to_s
            @bitmap_font.render px + xo, py + @tileset.cell_height, pz
          end
        end
        super x, y, z
      end

    end
  end
end
