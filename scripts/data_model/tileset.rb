module ES
  module DataModel
    class Tileset < ::DataModel::Base
      field :filename,    type: String, default: ""
      field :cell_width,  type: Integer, default: 32
      field :cell_height, type: Integer, default: 32

      def export
        super.merge("&class" => self.class.to_s).stringify_keys
      end

      def to_tileset_head
        tileset_head = TilesetHead.new
        tileset_head.set(self.permit(:uri))
        tileset_head
      end
    end
  end
end
