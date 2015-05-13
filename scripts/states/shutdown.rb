module States
  class Shutdown < Base
    def init
      super
    end

    def update(delta)
      engine.quit
      super delta
    end
  end
end
