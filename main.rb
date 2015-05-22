GLFW.init

require 'core/application_base'
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
rescue Exception => exc
ensure
  app.pre_shutdown engine
  engine.shutdown
  app.post_shutdown engine
end

raise exc if exc
