class DataMatrix

  ###
  # Determines if position is inside the DataMatrix
  # @overload xy_pos_inside?(x, y)
  # @overload xy_pos_inside?(vec2)
  # @return [Boolean]
  ###
  def xy_pos_inside?(*args)
    px, py = *Vector2.obj_to_vec2_a(args.size > 1 ? args : args.first)
    px.between?(0, xsize) && py.between?(0, ysize)
  end

  ###
  # Determines if position is inside the DataMatrix
  # @overload pos_inside?(x, y, z)
  # @overload pos_inside?(vec3)
  # @return [Boolean]
  ###
  def pos_inside?(*args)
    px, py, pz = *Vector3.obj_to_vec3_a(args.size > 1 ? args : args.first)
    px.between?(0, xsize) && py.between?(0, ysize) && pz.between?(0, zsize)
  end

end