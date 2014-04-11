module ES
  module DataModel
    class Chunk < BaseModel

      field :data,    type: DataMatrix, allow_nil: true, default: nil
      field :flags,   type: DataMatrix, allow_nil: true, default: nil
      field :passage, type: Table,      allow_nil: true, default: nil

    end
  end
end