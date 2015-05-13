module Moon
  class DataMatrix
    ###
    # Determines if position is inside the DataMatrix
    # @overload contains_xy?(x, y)
    # @overload contains_xy?(vec2)
    # @return [Boolean]
    ###
    def contains_xy?(*args)
      px, py = *Moon::Vector2.extract(args.singularize)
      px.between?(0, xsize) && py.between?(0, ysize)
    end

    ###
    # Determines if position is inside the DataMatrix
    # @overload contains_pos?(x, y, z)
    # @overload contains_pos?(vec3)
    # @return [Boolean]
    ###
    def contains_pos?(*args)
      px, py, pz = *Moon::Vector3.extract(args.singularize)
      px.between?(0, xsize) && py.between?(0, ysize) && pz.between?(0, zsize)
    end

    def self.coerce(obj)
      if obj.is_a?(Hash)
        load obj
      else
        obj
      end
    end
  end
end
