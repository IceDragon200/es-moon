#
class Application
  # @param [Moon::Engine] engine
  def configure(engine)
  end

  # @param [Moon::Engine] engine
  def post_setup(engine)
  end

  # @param [Moon::Engine] engine
  def load_scripts(engine)
    require 'core/load'
    require 'scripts/load'
  end

  # @param [Moon::Engine] engine
  def start(engine)
  end

  # @param [Moon::Engine] engine
  # @param [Float] delta
  def step(engine, delta)
  end

  # @param [Moon::Engine] engine
  def pre_shutdown(engine)
  end

  # @param [Moon::Engine] engine
  def post_shutdown(engine)
  end
end

require 'application' if File.exist?('application.rb')

app = Application.new
engine = Moon::Engine.new do |e, delta|
  app.step e, delta
end

begin
  app.configure engine
  engine.setup
  app.post_setup engine

  app.load_scripts engine

  app.start engine
  engine.main
ensure
  app.pre_shutdown engine
  engine.shutdown
  app.post_shutdown engine
end
