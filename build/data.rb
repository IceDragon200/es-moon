#!/usr/bin/env ruby

# EDOS data building
$: << File.expand_path("../", File.dirname(__FILE__))

require "yaml"

require 'core/core_ext'
require 'core/data_model'

# Duck typing
module Moon
  class Vector2 < Moon::DataModel::Metal

    field :x,      type: Numeric, default: 0.0
    field :y,      type: Numeric, default: 0.0

    def initialize(*args, &block)
      case args.size
      when 1
        super args.first, &block
      when 2
        x, y = *args
        super x: x, y: y, &block
      else
        super x: 0.0, y: 0.0, &block
      end
    end

    def to_a
      return x, y
    end
  end
  class Vector3 < Moon::DataModel::Metal

    field :x,      type: Numeric, default: 0.0
    field :y,      type: Numeric, default: 0.0
    field :z,      type: Numeric, default: 0.0

    alias :r :x
    alias :r= :x=
    alias :g :y
    alias :g= :y=
    alias :b :z
    alias :b= :z=

    def initialize(*args, &block)
      case args.size
      when 1
        super args.first, &block
      when 3
        x, y, z = *args
        super x: x, y: y, z: z, &block
      else
        super x: 0.0, y: 0.0, z: 0.0, &block
      end
    end

    def to_a
      return x, y, z
    end

  end
  class Vector4 < Moon::DataModel::Metal

    field :x,      type: Numeric, default: 0.0
    field :y,      type: Numeric, default: 0.0
    field :z,      type: Numeric, default: 0.0
    field :w,      type: Numeric, default: 0.0

    alias :r :x
    alias :r= :x=
    alias :g :y
    alias :g= :y=
    alias :b :z
    alias :b= :z=
    alias :a :w
    alias :a= :w=

    def initialize(*args, &block)
      case args.size
      when 1
        super args.first, &block
      when 4
        x, y, z, w = *args
        super x: x, y: y, z: z, w: w, &block
      else
        super x: 0.0, y: 0.0, z: 0.0, w: 0.0, &block
      end
    end

    def to_a
      return x, y, z, w
    end

  end
  class Rect < Moon::DataModel::Metal

    field :x,      type: Integer, default: 0
    field :y,      type: Integer, default: 0
    field :width,  type: Integer, default: 0
    field :height, type: Integer, default: 0

    def initialize(x, y, width, height, &block)
      super x: x, y: y, width: width, height: height, &block
    end

  end
end

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
require 'scripts/core_ext'
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
    obj.save_file
  end
end
