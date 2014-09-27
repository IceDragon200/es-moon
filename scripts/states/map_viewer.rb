module States
  class MapViewer < Base
    def init
      super

      create_spriteset
    end

    def create_spriteset
      map = Database.find(:map, uri: "/maps/school/f1")
      @map_renderer = EditorMapRenderer.new
      @map_renderer.show_underlay = true
      editor_map = map.to_editor_map
      editor_map.chunks = map.chunks.map do |chunk_head|
        chunk = Database.find(:chunk, uri: chunk_head.uri)
        editor_chunk = chunk.to_editor_chunk
        editor_chunk.position = chunk_head.position
        editor_chunk.tileset = Database.find(:tileset, uri: chunk.tileset.uri)
        editor_chunk
      end
      @map_renderer.dm_map = editor_map
      @map_renderer.dm_map.ppd_dm

      @renderer.add @map_renderer
    end
  end
end
