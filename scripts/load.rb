include Moon

#Moon::Screen.resize(800, 600)

require 'scripts/mixin'
require 'scripts/core_ext'
require 'scripts/version'
require 'scripts/cache'
require 'scripts/entity_system'
require 'scripts/renderers'
require 'scripts/ui'
require 'scripts/core'
require 'scripts/const'
require 'scripts/data_model'
require 'scripts/database'
require 'scripts/states'
require 'scripts/helpers'
require 'scripts/adapters'
##
require 'scripts/test'
require 'scripts/data'

ES.init_caches

State.push ES::States::Shutdown
State.push ES::States::Title
#State.push Roadmap::StateGridBasedCharacterMovement
#State.push Roadmap::StateCharacterMovement
#State.push Roadmap::StateDisplaySpriteOnTilemap
#State.push Roadmap::StateDisplayTilemapWithChunks
#State.push Roadmap::StateDisplayChunk
#State.push Roadmap::StateDisplaySpriteOnScreen
#State.push StateMusicLayering
#State.push StateCharacterWalkTest
#State.push StateTypingTest
#State.push StateUITest01
#State.push ES::States::Splash
