module ES
  module DataModel
    class Chunk < ::DataModel::Base
      field :data,     type: DataMatrix, allow_nil: true, default: nil
      field :flags,    type: DataMatrix, allow_nil: true, default: nil
      field :passages, type: Table,      allow_nil: true, default: nil
      field :tileset,  type: Tileset,    allow_nil: false, default: proc{Tileset.new}
    end
  end
end
