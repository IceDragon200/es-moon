require 'scripts/models/base'

module Models
  class Map < Base
    EMPTY_ARRAY = []

    field :tileset_id, type: String,           default: ''
    field :data,       type: Moon::DataMatrix, default: nil
    field :zones,      type: Moon::DataMatrix, default: nil
    array :nodes,      type: Hash

    # @return [self]
    def clear_caches
      @passage_table = nil
      @zone_to_node_map = nil
      self
    end

    # Resizes the map's data and refreshe the passage table
    #
    # @return [self]
    def resize(w, h)
      data.resize(w, h, data.zsize)
      clear_caches
      self
    end

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

    # Constructs a static passage table from the map, it is expected that
    # the data will not be modified during runtime, else call clear_cache
    # which will destroy all the cached data and rebuild it on next request
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

    # Creates a zone to node list Hash
    # By providing a zone_id it will return a list of nodes which reference it
    private def build_zone_to_node_map
      mapping = {}
      nodes.each do |node|
        if zone_id = node['zone_id']
          (mapping[zone_id] ||= []).push(node)
        end
      end
      mapping
    end

    # The map's passage table
    #
    # @return [Moon::Table]
    def passage_table
      @passage_table ||= build_passage_table
    end

    # The map's node table, values are the node's index
    #
    # @return [Moon::Table]
    def zone_to_node_map
      @zone_to_node_map ||= build_zone_to_node_map
    end

    # zone_id at the given position, if any
    #
    # @param [Integer] x
    # @param [Integer] y
    # @param [Integer] z
    # @return [Integer] zone_id  (-1 is disabled)
    def zone_at(x, y, z = 0)
      zones[x, y, z]
    end

    # Returns a list of zones at the given tile
    #
    # @param [Integer] x
    # @param [Integer] y
    # @return [Array<Integer>] zones
    def zones_at(x, y)
      zones.zsize.times.each_with_object([]) do |z, ary|
        zone_id = zone_at(x, y, z)
        ary << zone_id if zone_id >= 0
      end
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

    # Returns the list of nodes present at this at the given position if any
    #
    # @param [Integer] x
    # @param [Integer] y
    # @return [Hash, nil]
    def nodes_at(x, y)
      zone_id = zone_at(x, y)
      zone_to_node_map[zone_id] || EMPTY_ARRAY
    end

    # Returns the first transfer node at the given position
    #
    # @param [Integer] x
    # @param [Integer] y
    # @return [Hash, nil]
    def transfer_node_at(x, y)
      nodes_at(x, y).find { |node| node['type'] == 'transfer' }
    end
  end
end
