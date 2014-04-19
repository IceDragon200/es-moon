class Vector3

  def reduce(*args)
    rx, ry, rz = Vector3.obj_to_vec3_a(args.size > 1 ? args : args.first)
    Vector3.new (x / rx).floor * rx, (y / ry).floor * ry, (z / rz).floor * rz
  end

end