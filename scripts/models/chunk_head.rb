module ES
  class ChunkHead < Moon::DataModel::Metal
    field :uri,      type: String,  default: ""
    field :position, type: Moon::Vector3, default: proc{|t|t.new(0,0,0)}
  end
end
