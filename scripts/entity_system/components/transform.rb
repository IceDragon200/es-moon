require 'scripts/entity_system/component'

class TransformComponent < ES::EntitySystem::Component
  register :transform

  field :position, type: Moon::Vector3, default: -> (t, _) { t.model.new }
  field :rotation, type: Float,         default: 0
  field :scale,    type: Moon::Vector3, default: -> (t, _) { t.model.new }

  def matrix
    @matrix ||= Moon::Matrix4.new(1.0)
    if @dirty
      @matrix.clear
      @matrix.scale!(scale)
      @matrix.rotate!([0, 0, 1], rotation)
      @matrix.translate!(position)
      @dirty = false
    end
    @matrix
  end

  alias :set_position :position=
  def position=(position)
    set_position position
    @dirty = true
  end

  alias :set_rotation :rotation=
  def rotation=(rotation)
    set_rotation rotation
    @dirty = true
  end

  alias :set_scale :scale=
  def scale=(scale)
    set_scale scale
    @dirty = true
  end
end
