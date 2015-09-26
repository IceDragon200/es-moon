GLFW.init

class Application
  class << self
    attr_accessor :instance
  end

  def initialize
    Application.instance = self
  end

  # @param [Moon::Engine] engine
  def configure(engine)
  end

  # @param [Moon::Engine] engine
  def post_setup(engine)
  end

  # @param [Moon::Engine] engine
  def load_scripts(engine)
    GC.disable
    require 'core/load'
    require 'scripts/load'
  ensure
    GC.enable
  end

  # Called right before the engine enters its main loop
  # @param [Moon::Engine] engine
  def start(engine)
  end

  # Called every frame by the engine
  #
  # @param [Moon::Engine] engine
  # @param [Float] delta
  def step(engine, delta)
  end

  # Called before the engine is shutdown
  #
  # @param [Moon::Engine] engine
  def pre_shutdown(engine)
  end

  # Called after the engine has shutdown
  #
  # @param [Moon::Engine] engine
  def post_shutdown(engine)
    Application.instance = nil if Application.instance.equal?(self)
  end
end

require 'application' if File.exist?('application.rb')

app = Application.new
engine = Moon::Engine.new do |e, delta|
  app.step e, delta
end

exc = nil
begin
  app.configure engine
  engine.setup
  app.post_setup engine

  app.load_scripts engine

  app.start engine
  engine.main
rescue Exception => exception
  exc = [exception, exception.backtrace.dup]
ensure
  app.pre_shutdown engine
  engine.shutdown
  app.post_shutdown engine
end

if exc
  puts exc[0].inspect
  exc[1].each do |line|
    puts "\t#{line}"
  end
end
