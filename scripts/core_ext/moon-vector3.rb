module Moon
  class Vector3
    # Returns the properties of the vector as an Array of Integers
    #
    # @return [Array<Integer>]
    def to_int_ary
      [x.to_i, y.to_i, z.to_i]
    end

    # Sets the properties of the vector to 0
    #
    # @return [self]
    def zero!
      set(0, 0, 0)
      self
    end

    def reduce(*args)
      rx, ry, rz = *Vector3.extract(args.size > 1 ? args : args.first)
      Vector3.new (x / rx).floor * rx, (y / ry).floor * ry, (z / rz).floor * rz
    end
  end
end
