class Vector2

  def reduce(*args)
    rx, ry = Vector2.obj_to_vec2_a(args.size > 1 ? args : args.first)
    Vector2.new (x / rx).floor * rx, (y / ry).floor * ry
  end

end