module ES
  module UI
    class TileInfo < RenderContainer

      attr_accessor :map           # GameObject::Map
      attr_accessor :tile_position # Vector2
      attr_accessor :tileset       # Spritesheet

      def initialize
        super
        @map = nil
        @tile_position = Vector2.new(0, 0)
        @tileset = nil # spritesheet
        @text = Text.new("", Cache.font("uni0553", 14))

        @block_ss = Cache.block "e008x008.png", 8, 8
        #@block_ss = Cache.block "e016x016.png", 16, 16
      end

      def info
        @map.tile_data(*@tile_position.floor)
      end

      def render(x=0, y=0, z=0)
        if @map && @tileset
          px = x + @position.x
          py = y + @position.y
          pz = z + @position.z

          data = self.info
          chunk = data[:chunk]
          passage = data[:passage]

          @text.string = "" +
                                "position:       #{data[:data_position]}\n" +
                                "chunk_id:       #{chunk.id}\n" +
                                "chunk_name:     #{chunk.name}\n" +
                                "chunk_data_pos: #{data[:chunk_data_position]}\n" +
                                "chunk_position: #{chunk.position.to_a}\n" +
                                "passage:        #{passage}\n" +
                                "" # placeholder

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
          py += @block_ss.cell_height * 3

          data[:data].each_with_index do |tile_id, i|
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