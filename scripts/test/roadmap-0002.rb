module Roadmap
  class StateDisplayChunk < State
    def init
      super
      @chunk = Database.find(:chunk, name: "school_f1/room/baron")
      @tilemap = Tilemap.new do |t|
        filename = "oryx_lofi_fantasy/4x/lofi_environment_4x.png"
        t.tileset = ES.cache.tileset filename, 32, 32
        t.data = @chunk.data
      end
    end

    def update(delta)
      super delta
    end

    def render
      super
      @tilemap.render(0, 0, 0)
    end
  end
end
