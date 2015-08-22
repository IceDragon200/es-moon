module ES
  module UI
    class TilePanel < Moon::RenderContext
      class PanelCursor < Cursor2
        field :wrap_size, type: Moon::Vector2, default: Moon::Vector2.new(0, 0)

        def adjust_position(position)
          return position if wrap_size.x.zero? || wrap_size.y.zero?
          Moon::Vector2.new(position.x.to_i % wrap_size.x.to_i,
                            position.y.to_i % wrap_size.y.to_i)
        end
      end

      # @return [Cursor2]
      attr_reader :cursor

      # @return [Moon::Spritesheet]
      attr_reader :tileset

      # @return [Integer]
      attr_reader :tile_id

      # @return [Integer]
      attr_accessor :visible_cols

      # @return [Integer]
      attr_accessor :visible_rows

      def pre_initialize
        super
        @tileset = nil # spritesheet
        @visible_rows = 8
        @visible_cols = 8

        @tilesize = Moon::Vector2.new 32, 32
        @cursor = PanelCursor.new
        @cursor.position = Moon::Vector2.new 0, 0

        @text = Moon::Label.new '', ES.game.font_cache.font('uni0553', 16)

        texture = ES.game.texture_cache.block 'e032x032.png'
        @block_ss = Moon::Spritesheet.new texture, 32, 32

        background_texture = ES.game.texture_cache.ui 'hud_mockup_4x.png'
        @background_s = Moon::Sprite.new background_texture
        @background_s.clip_rect = Moon::Rect.new 24, 216, 272, 272
        @tile_box = Moon::Sprite.new background_texture
        @tile_box.clip_rect = Moon::Rect.new 696, 216, 48, 48
        @scroll_bar = Moon::Sprite.new background_texture
        @scroll_bar.clip_rect = Moon::Rect.new 408, 216, 48, 272
        @scroll_knob = Moon::Sprite.new background_texture
        @scroll_knob.clip_rect = Moon::Rect.new 480, 224, 32, 32

        @tile_id = 0
        @row_index = 0
      end

      def w
        @w ||= @tileset ? @tileset.cell_w * @visible_cols : 0
      end

      def h
        @h ||= 16 + (@tileset ? @tileset.cell_h * @visible_rows : 0)
      end

      def initialize_events
        super
        @cursor.on :moved do |e|
          @tile_id = position_to_tile_id e.position
          recalculate_row_index
        end
      end

      def position_to_tile_id(pos)
        (pos.x + pos.y * @visible_cols).to_i
      end

      def row_count
        rows, mod = *@tileset.cell_count.divmod(@visible_cols)
        (rows + mod.clamp(0, 1)).to_i
      end

      def recalculate_row_index
        row = (@tile_id / @visible_cols).to_i
        @row_index = (row - (@visible_rows / 2).to_i).clamp(0, (row_count - @visible_rows).to_i)
      end

      def tileset=(tileset)
        @tileset = tileset
        @cursor.wrap_size.set(@visible_cols, row_count)
        resize(nil, nil)
      end

      def tile_id=(n)
        old = @tile_id
        @tile_id = n.to_i
        if @tile_id < 0
          @cursor.position.set(-1, -1)
        elsif @tile_id != old
          @cursor.moveto((@tile_id.to_i % @visible_cols).floor,
                         (@tile_id.to_i / @visible_cols).floor)
        end
      end

      #
      def select_tile(*args)
        sx, sy = *Moon::Vector2.extract(args.singularize)
        pos = screen_to_relative(sx, sy).reduce(@tilesize)
        if relative_contains_pos?(pos)
          ps = (pos / @tilesize).floor
          self.tile_id = ps.x + (ps.y + @row_index) * @visible_cols
        end
      end

      def render_content(x, y, z, options)
        @background_s.render x - 8, y + 8, z

        row = @row_index * @visible_cols
        if @tileset
          vis = @visible_rows * @visible_cols
          vis.times do |i|
            tx = (i % @visible_cols) * @tileset.cell_w
            ty = (i / @visible_cols).floor * @tileset.cell_h
            @tileset.render x + tx, y + ty + 16, z, row + i
          end

          bx, by = x + @background_s.w + 8, y + 8
          @scroll_bar.render bx, by, z
          inc = @tile_id.to_f / @tileset.cell_count
          knob_y = by + 8 + inc * @visible_rows * @tilesize.y
          @scroll_knob.render bx + 8, knob_y, z

          cp = @cursor.position * @tilesize
          cp.y -= @row_index * @tilesize.y
          @block_ss.render x + cp.x, y + cp.y + 16, z, 1
        end


        if relative_contains_pos?(cp)
          ty = y - @tile_box.h
          @tile_box.render x, ty, z
          if @tileset
            @tileset.render x + 8, ty + 8, z, @tile_id
          end
          text_y = ty + ((@tile_box.h - @text.h) / 2).to_i
          @text.string = "Tile #{@tile_id}"
          @text.render x + @tile_box.w + 4, text_y, z
        end
      end
    end
  end
end
