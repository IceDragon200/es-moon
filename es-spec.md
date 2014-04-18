es-spec
=======
Updated: [2014/04/12]

Thank you for taking the time to peak at the es-spec.

1. No position is absolute
2. No #x, #y, use a Vector2/3 as #position instead
   Unless its a base class in which you can't do anything about it.
3. No #width, #height, use a Vector2/3 as #size instead
   Unless its a base class in which you can't do anything about it.
4. When storing a reference to a DataModel, prefix the variable with "d"