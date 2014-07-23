module Roadmap
  class StateDisplayTilemapWithChunks < State
    def init
      super
      @tilemaps = []
      @map = Database.find(:map, uri: "/maps/school/f1")
      @map.chunks.each_with_index do |refhead, i|
        chunk = Database.find(:chunk, uri: refhead.fetch("uri"))
        @tilemaps << Tilemap.new do |t|
          filename = "oryx_lofi_fantasy/4x/lofi_environment_4x.png"
          t.tileset = ES.cache.tileset filename, 32, 32
          t.data = chunk.data
          t.position.set(refhead["position"] * 32)
        end
      end
    end

    def update(delta)
      super delta
    end

    def render
      super
      @tilemaps.each(&:render)
    end
  end
end
