require 'scripts/models/base'
require 'scripts/models/tileset'

module ES
  class TilePalette < Base
    field :tileset, type: Tileset,   default: ->(t, _) { t.model.new }
    array :tiles,   type: Integer
    field :columns, type: Integer,   default: 8

    def rows
      ((tiles.size / columns) + [1, tiles.size % columns].min).to_i
    end
  end
end
