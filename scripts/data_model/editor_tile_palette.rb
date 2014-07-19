module ES
  module DataModel
    class EditorTilePalette < ::DataModel::Base
      field :tiles,   type: [Integer], default: proc{[]}
      field :columns, type: Integer,   default: 8
    end
  end
end
