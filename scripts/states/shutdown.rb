module States
  class Shutdown < Base
    def init
      super
    end

    def start
      super
      engine.quit
    end
  end
end
