module Enum
  module Team
    enum_const :NEUTRAL, :ALLY, :ENEMY, :COUNT
  end

  module Direction
    DOWN_LEFT  = 1
    DOWN       = 2
    DOWN_RIGHT = 3
    LEFT       = 4
    CENTER     = 5 # used for entities that have no facing directions.
    RIGHT      = 6
    UP_LEFT    = 7
    UP         = 8
    UP_RIGHT   = 9
  end
end
