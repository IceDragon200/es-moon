# A middleware container for offsetting the view from a Camera2
class CameraContext < Moon::RenderContainer
  # @return [Camera2]
  attr_accessor :camera

  def apply_position_modifier(*args)
    pos = super(*args)
    pos -= Moon::Vector3[@camera.view_offset, 0] if @camera
    pos
  end
end
