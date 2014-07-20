module ES
  module DataModel
    class Chunk < ::DataModel::Base
      field :data,     type: DataMatrix,  allow_nil: true, default: nil
      field :flags,    type: DataMatrix,  allow_nil: true, default: nil
      field :passages, type: Table,       allow_nil: true, default: nil
      field :tileset,  type: TilesetHead, allow_nil: true, default: proc{|t|t.new}

      def to_editor_chunk
        editor_chunk = ES::DataModel::EditorChunk.new
        editor_chunk.set(to_h.exclude(:tileset))
        editor_chunk
      end
    end
  end
end
