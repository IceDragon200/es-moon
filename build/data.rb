#!/usr/bin/env ruby

# EDOS data building
$: << File.expand_path("../", File.dirname(__FILE__))
$: << File.expand_path("../modules", File.dirname(__FILE__))

require "yaml"

require 'core/core_ext'
require 'core/data_model'

require 'duck/load'

require 'core/vector2'
require 'core/vector3'
require 'core/vector4'
require 'core/rect'

require 'core/data_matrix'
require 'core/table'

require 'core/tilemap'

include Moon


require 'scripts/mixin/queryable'
require 'scripts/data_model'
require 'scripts/helpers'
require 'scripts/mixin'
require 'scripts/core_ext/array'
require 'scripts/core_ext/dir'
require 'scripts/core_ext/enumerable'
require 'scripts/core_ext/hash'
require 'scripts/core_ext/numeric'
require 'scripts/core_ext/string'
require 'scripts/core_ext/yaml'
require 'scripts/core_ext/moon-data_matrix'
require 'scripts/core_ext/moon-rect'
require 'scripts/core_ext/moon-table'
require 'scripts/core_ext/moon-vector2'
require 'scripts/core_ext/moon-vector3'
require 'scripts/core_ext/moon-vector4'
require 'scripts/const'

@pool = []

def pool(obj)
  @pool << obj
end

require_relative 'data/characters'
require_relative 'data/chunks'
require_relative 'data/entities'
require_relative 'data/maps'
require_relative 'data/popups'
require_relative 'data/tilesets'

Dir.chdir("../") do
  @pool.each do |obj|
    obj.validate
    obj.save_file
  end
end
