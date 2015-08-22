require 'scripts/models/tileset_head'

module ES
  class Chunk < Moon::DataModel::Base
    field_setting coerce_value: true, default: nil do
      field :data,     type: Moon::DataMatrix
      field :passages, type: Moon::Table
    end
    field :tileset,  type: TilesetHead, allow_nil: true, default: proc{|t|t.model.new}

    def to_editor_chunk
      editor_chunk = ES::EditorChunk.new
      each_pair do |key, value|
        next if key == :tileset
        editor_chunk.update_fields(key => value)
      end
      editor_chunk
    end
  end
end
