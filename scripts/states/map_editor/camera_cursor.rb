class CameraCursor < ::DataModel::Metal
  field :position, type: Vector3, default: proc{Vector3.new}
  field :velocity, type: Vector3, default: proc{Vector3.new}

  def update(delta)
    @position += @velocity * delta
  end
end
