require 'scripts/game'
require 'scripts/states/preload'

module ES
  class << self
    attr_accessor :game
  end
end

class StateBootstrap < State
  class StateManager < Moon::StateManager
    attr_accessor :game

    def initialize(game, engine)
      @game = game
      super engine
    end

    private def on_spawn(state)
      super
      state.game = @game
    end
  end

  def init
    ES.game = @game = Game.new
    @state_manager = StateManager.new @game, engine
  end

  def start
    load_config
    setup_states

    #export_map
  end

  def export_map
    map = {}
    ObjectSpace.each_object(Module) do |mod|
      mod.ancestors.each do |submod|
        unless submod == mod
          ary = (map[submod.to_s] ||= [])
          ary.push(mod.to_s)
          ary.uniq!
        end
      end
    end
    YAML.save_file('class_map.yml', map)
  end

  def load_config
    @config = YAML.load_file('config.yml').symbolize_keys
  end

  def setup_states
    @state_manager.push States::Shutdown
    @state_manager.push States::Title
    # Test Map
    #@state_manager.push States::FpMap
    ## Roadmap tests
    #@state_manager.push Roadmap::StateGridBasedCharacterMovement
    #@state_manager.push Roadmap::StateCharacterMovement
    #@state_manager.push Roadmap::StateDisplaySpriteOnTilemap
    #@state_manager.push Roadmap::StateDisplayTilemapWithChunks
    #@state_manager.push Roadmap::StateDisplayChunk
    #@state_manager.push Roadmap::StateDisplaySpriteOnScreen

    #@state_manager.push StateMusicLayering
    #@state_manager.push StateCharacterWalkTest
    #@state_manager.push StateTypingTest
    #@state_manager.push StateUITest01

    # Splash screens
    if @config[:splash]
      @state_manager.push States::EsSplash
      @state_manager.push States::MoonSplash
      @state_manager.push States::MrubySplash
    end

    @state_manager.push States::Preload
  end

  def update(delta)
    @game.scheduler.update delta
    @state_manager.step delta
  end
end
