require 'scripts/models/base'
require 'scripts/models/map'

module Models
  class TileData < Base
    field :valid,    type: Boolean,       default: false
    field :map,      type: Map,           allow_nil: true, default: nil
    field :position, type: Moon::Vector3, default: Moon::Vector3.zero
    field :passage,  type: Integer,       default: 0
    array :tile_ids, type: Integer
    array :zone_ids, type: Integer
    array :nodes,    type: Hash
  end
end
