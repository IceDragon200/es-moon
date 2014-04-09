module ES
  module DataModel
    class Chunk < BaseModel

      field :data, type: DataMatrix, allow_nil: true, default: nil

    end
  end
end