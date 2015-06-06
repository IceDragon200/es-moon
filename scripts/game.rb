class Game < Moon::DataModel::Metal
  field :map,   type: ES::EditorMap, default: nil
  field :world, type: ES::World,     default: nil
end
