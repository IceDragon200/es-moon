module Moon
  class Vector2
    def reduce(*args)
      rx, ry = *Vector2.extract(args.size > 1 ? args : args.first)
      Vector2.new (x / rx).floor * rx, (y / ry).floor * ry
    end
  end
end
