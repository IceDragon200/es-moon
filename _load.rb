#!/usr/bin/env ruby
# Testing script, launch this with ruby >= 2.1.x, this will use ruby to manually
# test the game scripts, since mruby's backtrace can be flaky at times.
require 'yaml'

$: << File.dirname(__FILE__)
$: << File.join(File.dirname(__FILE__), 'modules')
#STDERR.puts $:

require 'packages/std/core_ext/module'
require 'packages/std/mixins/serializable'
require 'packages/data_model/load'
require 'packages/moon-mock/load'
require 'core/load'
require 'scripts/load'

def tick
  step 0.016
end

def press_sim(key, mods = 0)
  Moon::Input.on_key(key, nil, :press, mods)
  tick
  Moon::Input.on_key(key, nil, :release, mods)
end

def repeat_sim(key, mods = 0)
  Moon::Input.on_key(key, nil, :press, mods)
  7.times { tick }
  Moon::Input.on_key(key, nil, :repeat, mods)
  tick
  Moon::Input.on_key(key, nil, :release, mods)
end

tick until States::Title === State.current

tick

menu = nil
# Find the title menu
State.current.tree.each do |e|
  menu = e.everyone.find { |e| e.tags.include?('#menu') }
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
