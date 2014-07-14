require "active_support/core_ext/string"
require "active_support/core_ext/module/delegation"
require "yaml"

$: << File.expand_path("../../", File.dirname(__FILE__))

require 'core/data_model'
require 'core/core/easer'
require 'scripts/mixin/queryable'
require 'scripts/es/data_model/metal-ext'
require 'scripts/es/data_model/base-ext'

class SequenceBuilder

  attr_reader :frames

  def initialize(frame_klass)
    @frame_klass = frame_klass
    @frames = []
  end

  def build_options_map
    @frames.each_with_object({}) do |frame, hash|
      hash.merge!(frame.to_h)
    end
  end

  def keyframe(options)
    @frames << @frame_klass.new.set!(options)
  end

  def incr(*keys)
    keyframe(keys.each_with_object(build_options_map) do |key, hash|
      hash[key] += 1
    end)
  end

  def decr(*keys)
    keyframe(keys.each_with_object(build_options_map) do |key, hash|
      hash[key] -= 1
    end)
  end

  def tween_to(easer, frame_count, options)
    current_state = build_options_map
    frame_count.times do |i|
      delta = i / (frame_count-1).to_f
      frame_options = {}
      options.each do |k, v|
        frame_options[k] = easer.ease(current_state.fetch(k), v, delta)
      end
      keyframe(frame_options)
    end
  end

end

def render_sequence(*args)
  builder = SequenceBuilder.new(*args)
  yield builder
  builder.frames.tap { |f| f.each(&:force_types) }
end
