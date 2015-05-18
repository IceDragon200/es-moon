class Application
  attr_accessor :state_main

  def start(engine)
    @state_main = StateBootstrap.new engine
  end

  def step(_, delta)
    @state_main.step delta
  end

  def configure(engine)
    engine.config[:width] = 1024
    engine.config[:height] = 640
  end
end
