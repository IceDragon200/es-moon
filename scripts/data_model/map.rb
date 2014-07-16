module ES
  module DataModel
    class Map < ::DataModel::Base
      ##
      # Array<Hash> chunks refhead
      field :chunks,         type: [Hash],    default: proc {[]}
    end
  end
end
