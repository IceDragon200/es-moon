class Game < Moon::DataModel::Metal
  field :map,   type: ES::EditorMap, default: nil
  field :world, type: ES::World,     default: nil
end

module Dataman
  def self.load_editor_map(query)
    map = ES::Map.find_by(query)
    em = map.to_editor_map
    em.chunks = map.chunks.map do |chunk_head|
      chunk = ES::Chunk.find_by(uri: chunk_head.uri)
      editor_chunk = chunk.to_editor_chunk
      editor_chunk.position = chunk_head.position
      editor_chunk.tileset = ES::Tileset.find_by(uri: chunk.tileset.uri)
      editor_chunk
    end
    em
  end
end
