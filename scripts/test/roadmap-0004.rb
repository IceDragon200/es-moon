module Roadmap
  class StateDisplaySpriteOnTilemap < State
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
      @world = World.new
      @char = @world.spawn
      @char_renderer = CharacterRenderer.new
      @char_renderer.character_attr = @char.add(:character,
                                                filename: "es-oryx/4x/character_4x.png",
                                                cell_width: 32,
                                                cell_height: 32)
      @char_renderer.position_attr = @char.add(:position)
    end

    def update(delta)
      @world.update(delta)
      super delta
    end

    def render
      super
      @tilemaps.each(&:render)
      @char_renderer.render
    end
  end
end
