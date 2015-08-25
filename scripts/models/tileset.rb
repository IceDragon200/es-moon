module ES
  class Tileset < Moon::DataModel::Base
    field :filename,        type: String,  default: ''
    array :passages,        type: Integer
    array :tile_properties, type: Integer
    field :cell_w,          type: Integer, default: 32
    field :cell_h,          type: Integer, default: 32
    field :columns,         type: Integer, default: 16

    def spritesheet_id
      "#{filename},#{cell_w},#{cell_h}"
    end
  end
end
