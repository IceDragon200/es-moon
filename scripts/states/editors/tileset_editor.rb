require 'scripts/models/tileset'

module States
  # A special editor state for modifying Tileset data
  class TilesetEditor < Base
    def init
      super
      @spritesheets = {}
    end

    def start
      super
      @sprite = Moon::Sprite.new(game.textures['placeholder/32x32'])
      @tilesets = []
      game.database.each_pair do |_, model|
        @tilesets << model if model.is_a?(Models::Tileset)
      end
    end
  end
end
