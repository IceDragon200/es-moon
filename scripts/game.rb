class Game < Moon::DataModel::Metal
  field :map,           type: ES::EditorMap,           default: nil
  field :world,         type: ES::EntitySystem::World, default: nil
  field :data_cache,    type: ES::DataCache,           default: ->(t, _) { t.model.new }
  field :font_cache,    type: ES::FontCache,           default: ->(t, _) { t.model.new }
  field :texture_cache, type: ES::TextureCache,        default: ->(t, _) { t.model.new }
  field :scheduler,     type: Moon::Scheduler,         default: ->(t, _) { t.model.new }
end
