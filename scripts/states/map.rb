module States
  class Map < Base
    def init
      super
      create_world
      create_map
      create_entity

      create_camera

      create_spriteset

      @camera.follow EntityPositionAdapter.new(@entity)

      #@pss_spritesheet8x = Moon::Spritesheet.new("resources/blocks/e008x008.png", 8, 8)
      #@pss_spritesheet = Moon::Spritesheet.new("resources/blocks/e032x032.png", 32, 32)
      register_actor_move

      @transform = Moon::Transform.new
    end

    def register_actor_move
      @input.on :press, :left do
        @entity[:position].x -= 1
      end
      @input.on :press, :right do
        @entity[:position].x += 1
      end
      @input.on :release, :left, :right do
        #@entity[:position].x = 0
      end

      @input.on :press, :up do
        @entity[:position].y -= 1
      end
      @input.on :press, :down do
        @entity[:position].y += 1
      end
      @input.on :release, :up, :down do
        #@entity[:position].y = 0
      end
    end

    def create_world
      @world = Moon::World.new
      @world.register(:movement)
    end

    def create_map
      #@map = ES::GameObject::Map.new
      #@map.setup(Database.find(:map, name: "school_f1"))
    end

    def create_entity
      @entity = @world.spawn
      @entity.add(position: { x: 0, y: 0 })
    end

    def create_camera
      @camera = Camera3.new
    end

    def create_spriteset
      map = Database.find(:map, uri: "/maps/school/f1")
      @map_renderer = EditorMapRenderer.new
      @map_renderer.show_underlay = true
      @map_renderer.show
      @map_renderer.dm_map = map.to_editor_map
      @map_renderer.dm_map.chunks = map.chunks.map do |chunk_head|
        chunk = Database.find(:chunk, uri: chunk_head.uri)
        editor_chunk = chunk.to_editor_chunk
        editor_chunk.position = chunk_head.position
        editor_chunk.tileset = Database.find(:tileset, uri: chunk.tileset.uri)
        editor_chunk
      end

      @renderer.add @map_renderer

      create_entity_sprite
    end

    def create_entity_sprite
      filename = "oryx_lofi_fantasy/3x/lofi_char_3x.png"

      texture = TextureCache.tileset filename
      @entity_sp = Moon::Spritesheet.new(texture, 24, 24)

      @entity_voffset =
        Moon::Vector3.new 32 - @entity_sp.cell_width,
                          32 - @entity_sp.cell_height,
                          0
      @entity_voffset /= 2
    end

    def update_map(delta)
      #@map.update delta
    end

    def update(delta)
      update_map delta

      super
    end

    def post_update(delta)
      @camera.update delta

      campos = -@camera.view.floor
      @map_renderer.position = campos
      super
    end

    def render
      campos = -@camera.view.floor
      charpos = @entity[:position]
      charpos = (campos + (Moon::Vector3[charpos.x, charpos.y, 0] * 32) + @entity_voffset).floor

      @entity_sp.render(*charpos, 0)#, transform: @transform)
      super
    end
  end
end
