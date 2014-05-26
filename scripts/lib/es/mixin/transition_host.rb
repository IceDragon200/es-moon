module TransitionHost

  def add_transition(*args, &block)
    (@transitions ||= []).push Transition.new(*args, &block)
  end

  def update_transitions(delta)
    return unless @transitions
    return if @transitions.empty?
    dead = []
    @transitions.each do |transition|
      transition.update delta
      dead << transition if transition.done?
    end
    @transitions -= dead
  end

end