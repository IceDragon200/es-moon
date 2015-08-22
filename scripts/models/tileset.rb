require 'scripts/models/tileset_head'

module ES
  class Tileset < Moon::DataModel::Base
    field :filename, type: String,  default: ''
    field :cell_w,   type: Integer, default: 32
    field :cell_h,   type: Integer, default: 32
    field :columns,  type: Integer, default: 16

    def to_tileset_head
      tileset_head = TilesetHead.new
      tileset_head.update_fields(self.to_h.permit(:uri))
      tileset_head
    end
  end
end
