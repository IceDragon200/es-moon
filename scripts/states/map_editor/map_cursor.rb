class MapCursor < ::DataModel::Metal
  field :position, type: Vector3, default: proc{Vector3.new}
end
