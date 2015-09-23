require 'scripts/models/tileset'

module UI
  # Better known as the Tile selection panel, this is the panel for selecting
  # tiles
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

    # @return [Models::Tileset]
    attr_reader :tileset

    # @return [Integer]
    attr_reader :tile_id

    # @return [Integer]
    attr_accessor :visible_cols

    # @return [Integer]
    attr_accessor :visible_rows

    protected def initialize_members
      super
      @tileset = nil
      @spritesheet = nil
      @visible_rows = 8
      @visible_cols = 8

      @tilesize = Moon::Vector2.new 32, 32

      @tile_id = 0
      @row_index = 0
    end

    protected def initialize_content
      super
      @cursor = PanelCursor.new
      @cursor.position = Moon::Vector2.new 0, 0

      @text = Moon::Label.new '', Game.instance.fonts['system.16']

      texture = Game.instance.textures['ui/tile_panel_cursor']
      @block_ss = Moon::Sprite.new texture

      background_texture = Game.instance.textures['ui/hud_mockup_4x']

      @background_s = Moon::Sprite.new background_texture
      @background_s.clip_rect = Moon::Rect.new 24, 216, 272, 272

      @tile_box = Moon::Sprite.new background_texture
      @tile_box.clip_rect = Moon::Rect.new 696, 216, 48, 48

      @passage_box = Moon::Sprite.new background_texture
      @passage_box.clip_rect = Moon::Rect.new 696, 216, 48, 48

      @scroll_bar = Moon::Sprite.new background_texture
      @scroll_bar.clip_rect = Moon::Rect.new 408, 216, 48, 272

      @scroll_knob = Moon::Sprite.new background_texture
      @scroll_knob.clip_rect = Moon::Rect.new 480, 224, 32, 32

      @passage_panel = UI::PassagePanel.new(
        spritesheet: Game.instance.spritesheets['ui/passage_icons_mini', 8, 8])
    end

    # @return [Integer]
    def w
      @w ||= @spritesheet ? @spritesheet.w * @visible_cols : 0
    end

    # @return [Integer]
    def h
      @h ||= 16 + (@spritesheet ? @spritesheet.h * @visible_rows : 0)
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
      rows, mod = *@spritesheet.cell_count.divmod(@visible_cols)
      (rows + mod.clamp(0, 1)).to_i
    end

    def recalculate_row_index
      row = (@tile_id / @visible_cols).to_i
      @row_index = (row - (@visible_rows / 2).to_i).clamp(0, (row_count - @visible_rows).to_i)
    end

    private def refresh_spritesheet
      @spritesheet = if @tileset
        Game.instance.spritesheets[@tileset.spritesheet_id]
      else
        nil
      end
    end

    def tileset=(tileset)
      @tileset = tileset
      refresh_spritesheet
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

    # @param [Array<Object>] args  something that can be extracted as a vector2
    def select_tile(*args)
      sx, sy = *Moon::Vector2.extract(args.singularize)
      pos = screen_to_relative(sx, sy).reduce(@tilesize)
      if contains_relative_pos?(pos)
        ps = (pos / @tilesize).floor
        self.tile_id = ps.x + (ps.y + @row_index) * @visible_cols
      end
    end

    def render_content(x, y, z, options)
      @background_s.render x - 8, y + 8, z
      return unless @spritesheet
      row = @row_index * @visible_cols
      vis = @visible_rows * @visible_cols
      vis.times do |i|
        tx = (i % @visible_cols) * @spritesheet.w
        ty = (i / @visible_cols).floor * @spritesheet.h
        @spritesheet.render x + tx, y + ty + 16, z, row + i
      end

      bx, by = x + @background_s.w + 8, y + 8
      @scroll_bar.render bx, by, z
      inc = @tile_id.to_f / @spritesheet.cell_count
      knob_y = by + 8 + inc * @visible_rows * @tilesize.y
      @scroll_knob.render bx + 8, knob_y, z

      cp = @cursor.position * @tilesize
      cp.y -= @row_index * @tilesize.y
      @block_ss.render x + cp.x, y + cp.y + 16, z

      if contains_relative_pos?(cp)
        ty = y - @tile_box.h
        @tile_box.render x, ty, z
        @spritesheet.render x + 8, ty + 8, z, @tile_id

        text_y = ty + ((@tile_box.h - @text.h) / 2).to_i
        @text.set string: "Tile #{@tile_id}", align: :left
        @text.render x + @tile_box.w + 4, text_y, z

        passage_id = @tileset.passages[@tile_id]

        tx = x + @background_s.w - @passage_box.w
        @passage_box.render tx, ty, z
        @passage_panel.passage = passage_id
        @passage_panel.render(
          tx + (@passage_box.w - @passage_panel.w) / 2,
          ty + (@passage_box.h - @passage_panel.h) / 2,
          z)

        text_y = ty
        @text.set string: "Passage #{passage_id}", align: :right
        @text.render tx - 4, text_y, z
      end
    end
  end
end
