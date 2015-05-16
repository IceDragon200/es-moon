#!/usr/bin/env ruby
# Testing script, launch this with ruby >= 2.1.x, this will use ruby to manually
# test the game scripts, since mruby's backtrace can be flaky at times.
require 'yaml'

$: << File.dirname(__FILE__)
$: << File.join(File.dirname(__FILE__), 'packages')
#STDERR.puts $:

module NVG
  class Color
  end
end

require 'packages/std/core_ext/object'
require 'packages/std/core_ext/module'
require 'packages/moon-inflector/load'
require 'packages/moon-serializable/load'
require 'packages/data_model/load'
require 'packages/moon-mock/load'
require 'core/load'
require 'scripts/load'

def tick(d = 0.016)
  step @engine, d
end

def press_sim(key, mods = 0)
  @engine.input.on_key(key, nil, :press, mods)
  tick
  @engine.input.on_key(key, nil, :release, mods)
end

def repeat_sim(key, mods = 0)
  @engine.input.on_key(key, nil, :press, mods)
  7.times { tick }
  @engine.input.on_key(key, nil, :repeat, mods)
  tick
  @engine.input.on_key(key, nil, :release, mods)
end


@engine = Moon::Engine.new do |_, d|
  tick d
end

@engine.setup

tick
tick until States::Title === @state_main.state_manager.current

tick

menu = nil
# Find the title menu
@state_main.state_manager.current.tree.each do |e|
  menu = e.value.everyone.find { |e| e.tags.include?('#menu') }
  break if menu
end

# Jump to the title menu's map_editor item
menu.jump_to_item(id: :map_editor)

STDOUT.flush
STDERR.flush
# Start the map editor
press_sim :enter

tick
tick
tick

puts '>> Now exiting'
