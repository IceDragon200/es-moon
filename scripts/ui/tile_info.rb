require 'scripts/models/tile_data'
require 'scripts/ui/passage_panel'

module UI
  # Panel that appears in the top left corner of the Map Editor, this displays
  # the tile, its passage and id
  class TileInfo < Moon::RenderContext
    attr_accessor :spritesheet   # Spritesheet
    attr_accessor :tile_data     # DataModel::TileData

    protected def initialize_members
      super
      @tile_data = Models::TileData.new
      @spritesheet = nil # spritesheet
      @text = Moon::Label.new '', Game.instance.fonts['system.16']
    end

    protected def initialize_content
      super
      @passage_panel = UI::PassagePanel.new(
        spritesheet: Game.instance.spritesheets['ui/passage_icons_mini', 8, 8])
    end

    # @param [Integer] x
    # @param [Integer] y
    # @param [Integer] z
    # @param [Hash] options
    protected def render_content(x, y, z, options)
      return unless @tile_data.valid

      tile_ids = @tile_data[:tile_ids] || []
      map = @tile_data[:map]
      passage = @tile_data[:passage]

      position = @tile_data[:position]

      map_id = map ? map.id : ''
      map_name = map ? map.name : ''

      @text.string = "#{map_id} -- #{map_name}"
      @text.render x, y, z

      y += @text.h + 8

      @passage_panel.passage = passage
      @passage_panel.render x, y, z

      # draw blocks for passage

      if @spritesheet
        y += @passage_panel.h
        tile_ids.each_with_index do |tile_id, i|
          next if tile_id < 0
          xo = @spritesheet.w * i


          @spritesheet.render x + xo, y, z, tile_id

          @text.string = tile_id.to_s
          @text.render x + xo, y + @spritesheet.h, z
        end
      end
    end
  end
end
