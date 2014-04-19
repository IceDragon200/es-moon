class Table

  ###
  # @param [String] str
  # @param [Hash<String, Integer>] strmap
  ###
  def set_from_strmap(str, strmap)
    str.bytes.each_with_index { |c, i| set_by_index(i, strmap[c.chr]) }
  end

  ###
  # Determines if position is inside the Table
  # @overload pos_inside?(x, y)
  # @overload pos_inside?(vec2)
  # @return [Boolean]
  ###
  def pos_inside?(*args)
    px, py = *Vector2.obj_to_vec2_a(args.size > 1 ? args : args.first)
    px.between?(0, xsize) && py.between?(0, ysize)
  end

end