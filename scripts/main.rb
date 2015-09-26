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

  attr_accessor :game
  attr_accessor :state_manager

  def init
    Game.instance = ES.game = @game = Game.new
    @state_manager = StateManager.new @game, engine
  end

  def start
    load_config
    setup_states
  end

  def load_config
    @game.config = YAML.load_file('config.yml').symbolize_keys
  end

  def setup_states
    @state_manager.push States::Preload
  end

  def update(delta)
    @game.scheduler.update delta
    @state_manager.step delta
  end
end
