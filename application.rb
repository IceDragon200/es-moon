class Application
  def start(engine)
    @state_main = StateBootstrap.new engine
  end

  def step(_, delta)
    @state_main.step delta
  end
end
