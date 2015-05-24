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
