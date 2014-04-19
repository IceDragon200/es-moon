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
      end

      def render(x, y, z)
        if @map && @tileset
          px = x + @position.x
          py = y + @position.y
          pz = z + @position.z

          data = @map.tile_data(*@tile_position.floor)
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
