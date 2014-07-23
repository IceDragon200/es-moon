class StateInputDelegate
  def initialize(controller)
    @controller = controller
    init
  end

  def init
    #
  end

  def modespace(input, mode)
    @_wrappers ||= []
    (@_modes ||=[]).push mode
    modes = @_modes.dup

    wrapper = InputContext.new(input) do |f, i, *a, &b|
      i.send(f, *a) { |*a2, &b2| b.call(*a2, &b2) if @mode.trace?(modes) }
    end

    @_wrappers.push wrapper

    yield @_wrappers.last

    @_wrappers.pop
    @_modes = @_modes.slice 0, @_modes.size-1
  end

  def register(input)
    #
  end
end
