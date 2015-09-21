module ES
  class Map < Moon::DataModel::Base
    field :data,       type: Moon::DataMatrix, default: nil
    field :tileset_id, type: String, default: ''

    def tileset
      Game.instance.database[tileset_id]
    end

    def w
      data.xsize
    end

    def h
      data.ysize
    end
  end
end
