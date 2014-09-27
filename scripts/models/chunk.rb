module ES
  class Chunk < Moon::DataModel::Base
    field :data,     type: Moon::DataMatrix, default: nil
    field :flags,    type: Moon::DataMatrix, default: nil
    field :passages, type: Moon::Table,      default: nil
    field :tileset,  type: TilesetHead, allow_nil: true, default: proc{|t|t.new}

    def to_editor_chunk
      editor_chunk = ES::EditorChunk.new
      editor_chunk.set(to_h.exclude(:tileset))
      editor_chunk
    end
  end
end
