module ES
  module DataModel
    class EditorChunk < ::DataModel::Base
      field :position, type: Vector3,    allow_nil: true, default: nil
      field :data,     type: DataMatrix, allow_nil: true, default: nil
      field :flags,    type: DataMatrix, allow_nil: true, default: nil
      field :passages, type: Table,      allow_nil: true, default: nil
      field :tileset,  type: Tileset,    allow_nil: true, default: nil

      def bounds
        Rect.new(position.x, position.y, data.xsize, data.ysize)
      end

      def to_chunk
        chunk = Chunk.new
        chunk.set(to_h.exclude(:position, :tileset))
        chunk.tileset = tileset.to_tileset_head
        chunk
      end

      def to_chunk_head
        chunk_head = ChunkHead.new
        chunk_head.position = position
        chunk_head.uri = uri
        chunk_head
      end
    end
  end
end
