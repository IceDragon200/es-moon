module ES
  class Map < Moon::DataModel::Base
    field :chunks,         type: [ChunkHead],    default: proc {[]}

    def to_editor_map
      editor_map = ES::EditorMap.new
      data = to_h.exclude(:chunks)
      editor_map.set(data)
      editor_map
    end
  end
end
