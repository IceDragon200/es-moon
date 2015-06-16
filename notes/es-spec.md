es-spec
=======
Thank you for taking the time to peek at the es-spec.

* No #x, #y, use a Vector2/3 as #position instead
   Unless its a base class in which you can't do anything about it.

```ruby
# NO
my_obj.x
my_obj.y

# YES
my_obj.position.x
my_obj.position.y
```

* No #w, #h, use a Vector2/3 as #size instead
   Unless its a base class in which you can't do anything about it, exception to this rule are `RenderContext`s and `Rect`.

```ruby
# NO
my_obj.w
my_obj.h

# YES
my_obj.size.x
my_obj.size.y
```

* Positions in a RenderContext are treated as relative to their parent, ALWAYS
* RenderContexts != RenderContainer
  Containers are meant to host other RenderContexts, while RenderContext derived classes are expected to be base renderables.

* Colors are normalized values.

```ruby
color.r # => 1.0
color.g # => 0.4
color.b # => 0.0
```
