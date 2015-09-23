module UI
  class TileInfo < Moon::RenderContext
    attr_accessor :tileset       # Spritesheet
    attr_accessor :tile_data     # DataModel::TileData

    def initialize_members
      super
      @tile_data = Models::TileData.new
      @tileset = nil # spritesheet
      @text = Moon::Label.new '', Game.instance.fonts['system.16']

      texture = Game.instance.textures['ui/passage_icons_mini']
      @block_ss = Moon::Spritesheet.new(texture, 8, 8)
    end

    def render_content(x, y, z, options)
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


      # draw blocks for passage
      if passage == Enum::Passage::NONE
        @block_ss.render x + @block_ss.w,
                         y + @block_ss.h,
                         z,
                         0
      else
        @block_ss.render x + @block_ss.w,
                         y,
                         z,
                         passage.masked?(Enum::Passage::UP) ? 1 : 0
        #
        @block_ss.render x,
                         y + @block_ss.h,
                         z,
                         passage.masked?(Enum::Passage::LEFT) ? 1 : 0
        #
        @block_ss.render x + @block_ss.w,
                         y + @block_ss.h,
                         z,
                         passage.masked?(Enum::Passage::ABOVE) ? 3 : 2
        #
        @block_ss.render x + @block_ss.w * 2,
                         y + @block_ss.h,
                         z,
                         passage.masked?(Enum::Passage::RIGHT) ? 1 : 0
        #
        @block_ss.render x + @block_ss.w,
                         y + @block_ss.h * 2,
                         z,
                         passage.masked?(Enum::Passage::DOWN) ? 1 : 0
      end

      if @tileset
        y += @block_ss.h * 3
        tile_ids.each_with_index do |tile_id, i|
          next if tile_id < 0
          xo = @tileset.w * i


          @tileset.render x + xo, y, z, tile_id

          @text.string = tile_id.to_s
          @text.render x + xo, y + @tileset.h, z
        end
      end
    end
  end
end
