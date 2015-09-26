require 'scripts/models/tile_data'
require 'scripts/ui/passage_panel'

module UI
  # Panel that appears in the top left corner of the Map Editor, this displays
  # the tile, its passage and id
  class TileInfo < Moon::RenderContext
    # @return [Moon::Spritesheet]
    attr_accessor :spritesheet
    # @return [Models::TileData]
    attr_accessor :tile_data

    protected def initialize_members
      super
      @tile_data = Models::TileData.new
    end

    protected def initialize_content
      super
      @spritesheet = nil # spritesheet
      @text = Moon::Label.new '', Game.instance.fonts['system.16']
      @passage_panel = UI::PassagePanel.new(
        spritesheet: Game.instance.spritesheets['ui/passage_icons_mini', 8, 8])
      @background = Moon::Sprite.new(Game.instance.textures['ui/hud_mockup_4x'])
      @background.clip_rect = Moon::Rect.new(696, 216, 48, 48)
    end

    # @param [Integer] x
    # @param [Integer] y
    # @param [Integer] z
    # @param [Hash] options
    protected def render_content(x, y, z, options)
      return unless @tile_data.valid

      map = @tile_data.map
      position = @tile_data.position

      map_id = map ? map.id : ''
      map_name = map ? map.name : ''

      @text.string = "#{map_id} -- #{map_name}"
      @text.render x, y, z

      y += @text.h + 8

      # draw blocks for passage
      @passage_panel.passage = @tile_data.passage
      @passage_panel.render x, y, z

      @text.string = "#{@passage_panel.passage}"
      @text.render x + @passage_panel.w + 8, y, z

      y += @text.h + 8

      @text.string = "zones: #{@tile_data.zone_ids}"
      @text.render x, y, z

      if @spritesheet
        y += @passage_panel.h + 16
        @tile_data.tile_ids.each_with_index do |tile_id, i|
          next if tile_id < 0
          xo = @background.w * i

          @background.render x + xo - 8, y - 8, z
          @spritesheet.render x + xo, y, z, tile_id

          @text.string = tile_id.to_s
          @text.render x + xo, y + @spritesheet.h, z
        end
      end
    end
  end
end
