module ES
  class Map < Moon::DataModel::Base
    array :chunks, type: ChunkHead

    def to_editor_map
      editor_map = ES::EditorMap.new
      data = to_h.exclude(:chunks)
      editor_map.update_fields(data)
      editor_map
    end
  end
end
