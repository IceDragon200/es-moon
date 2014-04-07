###
# State
###
class State

  ###
  # @type [Array<State>]
  ###
  @states = []

  ###
  # @type [???]
  ###
  attr_accessor :engine

  ###
  # @param [???] engine
  ###
  def initialize(engine=nil)
    @engine = engine
    @ticks = 0
    init
  end

  ###
  # Init
  # @return [void]
  ###
  def init
    #
  end

  ###
  # Per frame update function, called by moon
  # @return [void]
  ###
  def update
    @ticks += 1
  end

  ###
  # Per frame render function, called by moon
  # @return [void]
  ###
  def render
    #
  end

  ###
  # Callback function, called by the State class, when the state is
  # added to the stack
  # @return [void]
  ###
  def on_push
    #
  end

  ###
  # Callback function, called by the State class, when the state is
  # removed from the stack
  # @return [void]
  ###
  def on_pop
    #
  end

  ###
  # Swap the current state with (state)
  # @param [State] state
  # @return [State] old_state
  ###
  def self.change(state)
    old_state = @states[-1]
    old_state.on_pop
    @states[-1] = state
    state.on_push
    old_state
  end

  ###
  # Add a new state to the stack
  # @param [State] state
  # @return [State] state
  ###
  def self.push(state)
    @states.push state
    state.on_push
    state
  end

  ###
  # Remove the current state from the stack
  # @return [State] old_state
  ###
  def self.pop
    old_state = @states.pop
    old_state.on_pop
    old_state
  end

end