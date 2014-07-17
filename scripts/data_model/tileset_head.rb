module ES
  module DataModel
    class TilesetHead < ::DataModel::Metal
      field :uri,      type: String,  default: ""

      def export
        super.merge("&class" => self.class.to_s).stringify_keys
      end
    end
  end
end
