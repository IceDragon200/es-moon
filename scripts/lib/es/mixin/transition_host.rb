module TransitionHost

  ###
  # @param [] *args
  # @return [Transition]
  ###
  def add_transition(*args, &block)
    transition = Transition.new(*args, &block)
    (@transitions ||= []).push transition
    transition
  end

  ###
  # @param [Transition] transition
  # @return [Void]
  ###
  def remove_transition(transition)
    return unless @transitions
    @transitions.delete transition
  end

  ###
  # @param [Array<Transition>] transitions
  # @return [Void]
  ###
  def remove_transitions(transitions)
    @transitions -= transitions
  end

  ###
  # @param [Float] delta
  ###
  def update_transitions(delta)
    return unless @transitions
    return if @transitions.empty?
    dead = []
    @transitions.each do |transition|
      transition.update delta
      dead << transition if transition.done?
    end
    unless dead.empty?
      remove_transitions dead
    end
  end

  ###
  # Force all transitions to finish.
  # @return [Void]
  ###
  def finish_transitions
    return unless @transitions
    @transitions.each(&:finish)
  end

end
