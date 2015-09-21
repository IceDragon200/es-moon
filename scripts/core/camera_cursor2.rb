class CameraCursor2 < Cursor2
  field :velocity, type: Moon::Vector2, default: proc { |t| t.model.new }

  # @param [Float] delta
  def update(delta)
    @position += @velocity * delta
  end
end
