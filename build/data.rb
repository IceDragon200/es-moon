#!/usr/bin/env ruby

# EDOS data building
$: << File.expand_path('../', File.dirname(__FILE__))
$: << File.expand_path('../packages', File.dirname(__FILE__))

require 'yaml'

require 'std/core_ext'
require 'std/mixins'
require 'data_model/load'

require 'moon-mock/load'

require 'std/vector2'
require 'std/vector3'
require 'std/vector4'
require 'std/rect'
require 'std/event'
require 'std/state'

require 'data_bags/load'

require 'render_primitives/load'

require 'state_mvc/load'
require 'twod/load'

require 'es_map_editor/camera_cursor'
require 'es_map_editor/map_cursor'
require 'es_map_editor/models'

include Moon


require 'scripts/database'
require 'scripts/models'
require 'scripts/helpers'
require 'scripts/mixin'
require 'scripts/core_ext/array'
require 'scripts/core_ext/dir'
require 'scripts/core_ext/enumerable'
require 'scripts/core_ext/hash'
require 'scripts/core_ext/numeric'
require 'scripts/core_ext/string'
require 'scripts/core_ext/moon-data_matrix'
require 'scripts/core_ext/moon-vector2'
require 'scripts/core_ext/moon-vector3'
require 'scripts/core_ext/moon-vector4'
require 'scripts/const'

@pool = []

def pool(obj)
  @pool << obj
end

require_relative 'data/characters'
#require_relative 'data/chunks'
#require_relative 'data/entities'
#require_relative 'data/maps'
#require_relative 'data/popups'
#require_relative 'data/tilesets'

Dir.chdir('../') do
  @pool.each do |obj|
    obj.validate
    obj.save_file
  end
end
