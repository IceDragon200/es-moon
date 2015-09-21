require 'scripts/models/base'
require 'scripts/models/map'

module Models
  class TileData < Base
    field :valid,    type: Boolean,       default: false
    field :passage,  type: Integer,       default: 0
    array :tile_ids, type: Integer
    field :map,      type: Map,           allow_nil: true, default: nil
    field :position, type: Moon::Vector3, default: Moon::Vector3.zero
  end
end
