module States
  # The very first State to be pushed on the stack, and the very last to be
  # executed.
  # This state has one job, cleanly exit the Moon engine
  class Shutdown < Base
    # Called once the state is set as the current
    def start
      super
      engine.quit
    end
  end
end
