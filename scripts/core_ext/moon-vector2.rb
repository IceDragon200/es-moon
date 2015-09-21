module Moon
  class Vector2
    # Returns the properties of the vector as an Array of Integers
    #
    # @return [Array<Integer>]
    def to_int_ary
      [x.to_i, y.to_i]
    end

    # Sets the properties of the vector to 0
    #
    # @return [self]
    def zero!
      set(0, 0)
      self
    end

    def reduce(*args)
      rx, ry = *Vector2.extract(args.size > 1 ? args : args.first)
      Vector2.new (x / rx).floor * rx, (y / ry).floor * ry
    end
  end
end
