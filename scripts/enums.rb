module Enum
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
      '*' => ALL_ABOVE,
      ',' => DOWN,
      '<' => LEFT,
      '>' => RIGHT,
      '^' => UP,
      '`' => UP | ABOVE,
      '.' => DOWN | ABOVE,
      '(' => LEFT | ABOVE,
      ')' => RIGHT | ABOVE,
      'o' => ALL,
      'x' => NONE,
    }
  end

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

  module TacticsPhase
    IDLE           = -1
    INVALID        = 0
    BATTLE_START   = 1
    ROUND_NEXT     = 2
    ROUND_START    = 3
    NEXT_TICK      = 4
    TURN_START     = 5
    ACTION_NEXT    = 6
    ACTION_MAKE    = 7
    ACTION_PREPARE = 8
    ACTION_EXECUTE = 9
    ACTION_JUDGE   = 10
    TURN_END       = 11
    TURN_JUDGE     = 12
    ROUND_END      = 13
    ROUND_JUDGE    = 14
    BATTLE_END     = 15
    BATTLE_JUDGE   = 16
  end

  PHASE_NAME = {
    TacticsPhase::IDLE => "IDLE",
    TacticsPhase::INVALID => "INVALID",
    TacticsPhase::BATTLE_START => "BATTLE_START",
    TacticsPhase::ROUND_NEXT => "ROUND_NEXT",
    TacticsPhase::ROUND_START => "ROUND_START",
    TacticsPhase::NEXT_TICK => "NEXT_TICK",
    TacticsPhase::TURN_START => "TURN_START",
    TacticsPhase::ACTION_NEXT => "ACTION_NEXT",
    TacticsPhase::ACTION_MAKE => "ACTION_MAKE",
    TacticsPhase::ACTION_PREPARE => "ACTION_PREPARE",
    TacticsPhase::ACTION_EXECUTE => "ACTION_EXECUTE",
    TacticsPhase::ACTION_JUDGE => "ACTION_JUDGE",
    TacticsPhase::TURN_END => "TURN_END",
    TacticsPhase::TURN_JUDGE => "TURN_JUDGE",
    TacticsPhase::ROUND_END => "ROUND_END",
    TacticsPhase::ROUND_JUDGE => "ROUND_JUDGE",
    TacticsPhase::BATTLE_END => "BATTLE_END",
    TacticsPhase::BATTLE_JUDGE => "BATTLE_JUDGE",
  }
end
