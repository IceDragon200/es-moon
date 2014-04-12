module ES
  module DataModel
    class Map < BaseModel

      ##
      # Array<Hash> chunks lookup table
      field :chunks,         type: [Hash],    default: proc {[]}
      field :chunk_position, type: [Vector3], default: proc {[]}

    end
  end
end