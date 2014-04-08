class Vector3

  attr_accessor :x
  attr_accessor :y
  attr_accessor :z

  def initialize(x=0, y=0, z=0)
    @x = x
    @y = y
    @z = z
  end

  def coerce(a)
    return self, a
  end

  def to_a
    return @x, @y, @z
  end

  def obj_to_vec3a(obj)
    case obj
    when Numeric then return obj, obj, obj
    when Vector3 then return *obj
    else
      raise TypeError,
            "wrong argument type #{obj.class} (expected Numeric or Vector3)"
    end
  end

  def +(other)
    x, y, z = *obj_to_vec3a(other)
    Vector3.new(@x + x, @y + y, @z + z)
  end

  def -(other)
    x, y, z = *obj_to_vec3a(other)
    Vector3.new(@x - x, @y - y, @z - z)
  end

  def *(other)
    x, y, z = *obj_to_vec3a(other)
    Vector3.new(@x * x, @y * y, @z * z)
  end

  def /(other)
    x, y, z = *obj_to_vec3a(other)
    Vector3.new(@x / x, @y / y, @z / z)
  end

  def dot(other)
    x, y, z = *obj_to_vec3a(other)
    @x * x + @y * y + @z * z
  end

  #def cross(other)
  #  x, y, z = *obj_to_vec3a other
  #  @x * x + @y * y + @z * z
  #end

  private :obj_to_vec3a

end