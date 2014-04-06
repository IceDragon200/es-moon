class State

  @states = []

  attr_accessor :engine

  def initialize(engine=nil)
    @engine = engine
    @ticks = 0
  end

  def update
    @ticks += 1
  end

  def render
    #
  end

  def on_push
    #
  end

  def on_pop
    #
  end

  def self.change(state)
    old_state = @states[-1]
    old_state.on_pop
    @states[-1] = state
    state.on_push
    old_state
  end

  def self.push(state)
    @states.push state
    state.on_push
    state
  end

  def self.pop
    old_state = @states.pop
    old_state.on_pop
    old_state
  end

end