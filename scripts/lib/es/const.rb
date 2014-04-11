module ES
  module Passage

    NONE      = 0                                # 0000 0000
    UP        = 1                                # 0000 0001
    LEFT      = 2                                # 0000 0010
    RIGHT     = 4                                # 0000 0100
    DOWN      = 8                                # 0000 1000
    ABOVE     = 16                               # 0001 0000
    ALL       = LEFT | RIGHT | UP | DOWN         # 0000 1111
    ALL_ABOVE = LEFT | RIGHT | UP | DOWN | ABOVE # 0001 1111

    STRMAP = {
      "*" => ALL_ABOVE,
      "," => DOWN,
      "<" => LEFT,
      ">" => RIGHT,
      "^" => UP,
      "`" => UP | ABOVE,
      "." => DOWN | ABOVE,
      "(" => LEFT | ABOVE,
      ")" => RIGHT | ABOVE,
      "o" => ALL,
      "x" => NONE,
    }

  end

  module ChunkFlag

    NONE            = 0        # 0000 0000 # no flag
    # up and down offsets will conflict, left and right offsets will conflict
    OFF_UP          = 16       # 0001 0000 # enable offset up
    OFF_LEFT        = 32       # 0010 0000 # enable offset left
    OFF_RIGHT       = 64       # 0100 0000 # enable offset right
    OFF_DOWN        = 128      # 1000 0000 # enable offset down
    # note that offset will overwrite each other
    QUART_OFF_TILE  = 1        # 0000 0001 # enable quater offset
    HALF_OFF_TILE   = 1|2      # 0000 0011 # enable half offset
    TQUART_OFF_TILE = 1|2|4    # 0000 0111 # enable 3/4 offset
    FULL_OFF_TILE   = 1|2|4|8  # 0000 1111 # enable full offset

  end
end