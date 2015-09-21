require 'scripts/core/material'
require 'scripts/caches'
require 'scripts/models/map'
require 'scripts/entity_system'

class Game < Moon::DataModel::Metal
  field :map,           type: ES::Map,                 default: nil
  field :world,         type: ES::EntitySystem::World, default: nil
  field :data_cache,    type: ES::DataCache,           default: ->(t, _) { t.model.new('Data') }
  field :font_cache,    type: ES::AssetCache,          default: ->(t, _) { t.model.new('Fonts') }
  field :texture_cache, type: ES::AssetCache,          default: ->(t, _) { t.model.new('Textures') }
  field :scheduler,     type: Moon::Scheduler,         default: ->(t, _) { t.model.new }
  dict  :materials,     key: String, value: Material
  dict  :config, key: Symbol, value: Object
end
