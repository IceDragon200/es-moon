module ES
  module DataModel
    class ChunkHead < ::DataModel::Metal
      field :uri,      type: String,  default: ""
      field :position, type: Vector3, default: proc{Vector3.new(0,0,0)}
    end
  end
end
