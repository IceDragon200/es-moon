module ES
  class TileData < Moon::DataModel::Base
    field :passage,             type: Integer,       default: 0
    array :tile_ids,            type: Integer
    field :chunk,               type: EditorChunk,   allow_nil: true, default: nil
    field :data_position,       type: Moon::Vector3, allow_nil: true
    field :chunk_data_position, type: Moon::Vector3, allow_nil: true
  end
end
