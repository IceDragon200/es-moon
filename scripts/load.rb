include Moon

#require 'entity'

require 'scripts/config'
require 'scripts/mixin'
require 'scripts/core_ext'
require 'scripts/cache'
require 'scripts/renderers'
require 'scripts/ui'
require 'scripts/es'
##
require 'scripts/test'


#require 'build/data' # only run once to generate the initial data stubs

require 'scripts/data'

ES.cache = ES::Cache.new

State.push ES::States::Shutdown
State.push ES::States::Title
State.push State::CharacterWalkTest
#State.push State::UITest01
#State.push ES::States::Splash
