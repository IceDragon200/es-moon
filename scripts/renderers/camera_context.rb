class CameraContext < Moon::RenderContainer
  attr_accessor :camera

  def apply_position_modifier(vec3 = 0)
    pos = super(vec3)
    pos -= Moon::Vector3[@camera.view_offset, 0] if @camera
    pos
  end
end
