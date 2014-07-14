module ES
  module DataModel
    class Chunk < ::DataModel::Base
      field :data,     type: DataMatrix, allow_nil: true, default: nil
      field :flags,    type: DataMatrix, allow_nil: true, default: nil
      field :passages, type: Table,      allow_nil: true, default: nil
    end
  end
end
