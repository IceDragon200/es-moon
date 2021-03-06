require 'scripts/core/material'
require 'scripts/caches'
require 'scripts/models/map'
require 'scripts/entity_system'

class Game < Moon::DataModel::Metal
  field :map,           type: Models::Map,             default: nil
  field :world,         type: ES::EntitySystem::World, default: nil
  field :database,      type: ES::AssetCache,          default: ->(t, _) { t.model.new('Database') }
  field :font_cache,    type: ES::AssetCache,          default: ->(t, _) { t.model.new('Fonts') } # deprecated accessor, use fonts instead
  field :texture_cache, type: ES::AssetCache,          default: ->(t, _) { t.model.new('Textures') } # deprecated accessor, use textures instead
  field :spritesheets,  type: ES::SpritesheetCache,    default: ->(t, _) { t.model.new('Spritesheets') }
  field :scheduler,     type: Moon::Scheduler,         default: ->(t, _) { t.model.new }
  dict  :materials,     key: String, value: Material
  dict  :config, key: Symbol, value: Object

  alias :fonts :font_cache
  alias :textures :texture_cache

  class << self
    attr_accessor :instance
  end
end
