module ES
  module States
    class Map < State

      def init
        super
        @camera = Camera2.new
        @map_pos = Vector3.new 0, 0, 0
        @tilemap = Tilemap.new do |tilemap|
          filename = "tileset_16x16_Jerom_CC-BY-SA-3.0_8_blue.png"
          chunk = ES::Database.find :chunk, name: "school_f1/baron.room"
          tilemap.tileset = Cache.tileset(filename, 16, 16)
          tilemap.data = chunk.data
        end
      end

      def update
        super
      end

      def render
        @tilemap.render(*(@map_pos - @camera.position.xyz))
        super
      end

    end
  end
end