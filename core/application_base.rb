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
    GC.disable
    require 'core/load'
    require 'scripts/load'
  ensure
    GC.enable
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
