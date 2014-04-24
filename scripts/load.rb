include Moon

require 'entity'

require 'scripts/config'
require 'scripts/lib'
require 'scripts/data'

State.push(ES::States::Shutdown)
State.push(ES::States::Title)
State.push(ES::States::Splash)