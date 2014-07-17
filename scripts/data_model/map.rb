module ES
  module DataModel
    class Map < ::DataModel::Base
      ##
      # Array<Hash> chunks refhead
      field :chunks,         type: [ChunkHead],    default: proc {[]}
    end
  end
end
