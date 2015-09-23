require 'scripts/models/base'

module Models
  class Map < Base
    field :data,       type: Moon::DataMatrix, default: nil
    field :tileset_id, type: String, default: ''

    # @return [Models::Tileset]
    def tileset
      Game.instance.database[tileset_id]
    end

    # The width of the map
    #
    # @return [Integer]
    def w
      data.xsize
    end

    # The height of the map
    #
    # @return [Integer]
    def h
      data.ysize
    end

    # Bounding rect of the map
    #
    # @return [Moon::Rect]
    def bounds
      Moon::Rect.new(0, 0, w, h)
    end

    # Constructs a static Passage table from the map, it is expected that
    # the data will not be modified during runtime
    private def build_passage_table
      table = Moon::Table.new(data.xsize, data.ysize)
      data.ysize.times do |y|
        data.xsize.times do |x|
          table[x, y] = 0
          (data.zsize - 1).downto(0) do |z|
            tile_id = tile_at(x, y, z)
            next if tile_id < 0
            passage_id = tileset.passages[tile_id]
            next if passage_id.masked?(Enum::Passage::ABOVE)
            table[x, y] = passage_id
            break
          end
        end
      end
      table
    end

    # The map's passage table
    #
    # @return [Moon::Table]
    def passage_table
      @passage_table ||= build_passage_table
    end

    # tile_id at the given position, if any
    #
    # @param [Integer] x
    # @param [Integer] y
    # @param [Integer] z
    # @return [Integer] tile_id
    def tile_at(x, y, z = 0)
      data[x, y, z]
    end

    # Passage data at the given position
    #
    # @param [Integer] x
    # @param [Integer] y
    # @return [Integer] passage_id
    def passage_at(x, y)
      passage_table[x, y]
    end
  end
end
