module ES
  module DataModel
    class Map < ::DataModel::Base

      ##
      # Array<Hash> chunks lookup table
      field :chunks,         type: [Hash],    default: proc {[]}
      field :chunk_position, type: [Vector3], default: proc {[]}

      def self.basepath
        "data/maps/"
      end

    end
  end
end
