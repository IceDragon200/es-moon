require 'scripts/game_config'
require 'scripts/lib'
require 'scripts/gdata'

State.push(ES::States::Shutdown)
State.push(ES::States::Title)
State.push(ES::States::Splash)