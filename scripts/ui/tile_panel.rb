module ES
  module UI
    class TilePanel < Moon::RenderContext
      attr_accessor :tileset       # Spritesheet
      attr_accessor :visible_rows
      attr_reader :tile_id         # Integer

      def initialize
        super
        @tileset = nil # spritesheet
        @visible_rows = 4
        @visible_cols = 8

        @tilesize = Moon::Vector2.new 32, 32
        @cursor_pos = Moon::Vector2.new 0, 0

        @text = Moon::Text.new "", FontCache.font("uni0553", 16)

        texture = TextureCache.block "e032x032.png"
        @block_ss = Moon::Spritesheet.new texture, 32, 32

        @tile_id = 0
        @row_index = 0
      end

      def width
        @tileset ? @tileset.cell_width * @visible_cols : 0
      end

      def height
        16 + (@tileset ? @tileset.cell_height * @visible_rows : 0)
      end

      def tile_id=(n)
        @tile_id = n.to_i
        @cursor_pos.set((@tile_id % @visible_cols).floor * @tilesize.x,
                        (@tile_id / @visible_cols).floor * @tilesize.y)
      end

      ###
      #
      ###
      def select_tile(*args)
        sx, sy = *Vector2.extract(args.singularize)
        pos = screen_to_relative(sx, sy).reduce(@tilesize)
        if relative_pos_inside?(pos)
          ps = (pos / @tilesize).floor
          self.tile_id = ps.x + (ps.y + @row_index) * @visible_cols
        end
      end

      def render_content(x, y, z, options)
        if @tileset
          vis = @visible_rows * @visible_cols
          @tileset.cell_count.times do |i|
            break if i >= vis
            tx = (i % @visible_cols) * @tileset.cell_width
            ty = (i / @visible_cols).floor * @tileset.cell_height
            @tileset.render x + tx, y + ty + 16, z, @row_index + i
          end
        end

        if relative_pos_inside?(@cursor_pos)
          @text.string = "tile #{@tile_id}"
          @text.render x, y, z
          @block_ss.render x + @cursor_pos.x, y + @cursor_pos.y + 16, z, 1
        end

        super
      end
    end
  end
end
