#!/usr/bin/env ruby
require "rm-macl/fallback/color"
Color = MACL::Fallback::Color
require "rm-macl/mtk/colors"
require "rm-macl/xpan/palette/export"
require "yaml"

filename = File.expand_path("../data/palette.yml", File.dirname(__FILE__))
data = MACL::Palette.new do |pal|
  pal.set_color "transparent",       0,   0,   0,   0
  pal.set_color "black",             0,   0,   0, 255
  pal.set_color "white",           255, 255, 255, 255

  # system
  pal.set_color "system/ok",         80, 200, 120, 255
  pal.set_color "system/info",       15,  82, 186, 255
  pal.set_color "system/warning",   236, 233, 162, 255
  pal.set_color "system/error",     194,  55,  65, 255
  pal.set_color "system/selection",  51, 181, 229, 255

  # attribute
  pal.set_color "attr/hp",          91, 179,  59, 255
  pal.set_color "attr/mp",          95, 149, 208, 255
  pal.set_color "attr/exp",        194,  55,  65, 255
  pal.set_color "attr/dur",        241, 194,  80, 255

  # elements
  pal.set_color "element/neutral", 172, 143, 121, 255
  pal.set_color "element/flare",   206, 102,  50, 255
  pal.set_color "element/aqua",    129, 174, 209, 255
  pal.set_color "element/land",     51, 178, 155, 255
  pal.set_color "element/atmos",   208, 176,  72, 255
  pal.set_color "element/lumi",    178, 215, 229, 255
  pal.set_color "element/shadow",   81,  64,  83, 255
end.to_basic_normalized_h

File.write(filename, {
  "format" => "float[rgba]",
  "colors" => data,
}.to_yaml)
