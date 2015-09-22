require 'scripts/entity_system/component'

module Components
  class Transform < Base
    register :transform

    field :position, type: Moon::Vector3, default: -> (t, _) { t.model.new }
    field :rotation, type: Float,         default: 0.0
    field :scale,    type: Moon::Vector3, default: -> (t, _) { t.model.new(1, 1, 1) }

    # Marks the transform as dirty, this will regenerate the internal Matrix
    # THIS IS AN API METHOD, YOU SHOULD TOTALLY LIKE, NOT USE IT AND STUFF.
    #
    # @return [self]
    # @api
    def dirty!
      @dirty = true
      self
    end

    # @return [Moon::Matrix4]
    # @api
    def matrix
      @matrix ||= Moon::Matrix4.new(1.0)
      if @dirty
        @matrix.clear
        @matrix.scale!(scale)
        @matrix.rotate!(rotation, [0, 0, 1])
        @matrix.translate!(position)
        @dirty = false
      end
      @matrix
    end

    alias :set_position :position=
    # @param [Vector3] position
    def position=(position)
      set_position position
      @dirty = true
    end

    alias :set_rotation :rotation=
    # @param [Float] rotation
    def rotation=(rotation)
      set_rotation rotation
      @dirty = true
    end

    alias :set_scale :scale=
    # @param [Vector3] scale
    def scale=(scale)
      set_scale scale
      @dirty = true
    end
  end
end
