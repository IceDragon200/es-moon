es-spec
=======
Updated: [2014/04/12]

Thank you for taking the time to peak at the es-spec.

1. No position is absolute

2. No #x, #y, use a Vector2/3 as #position instead
   Unless its a base class in which you can't do anything about it.
```ruby
# NO
my_obj.x
my_obj.y
# YES
my_obj.position.x
my_obj.position.y
```

3. No #width, #height, use a Vector2/3 as #size instead
   Unless its a base class in which you can't do anything about it.
```ruby
# NO
my_obj.width
my_obj.height
# YES
my_obj.size.x
my_obj.size.y
```

4. When storing a reference to a DataModel, prefix the variable with "d"
```ruby
# NO
@map = DataModel::Map.new
# YES
@dmap = DataModel::Map.new
```

5. RenderContainer != Container
  Containers are host components for holding widgets
  RenderContainers are layout elements, and are expected to have a
  render(x, y, z) function.

6. Colors are normalized
```ruby
color.r # => 1.0
color.g # => 0.4
color.b # => 0.0
```