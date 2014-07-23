require "scripts/states/map_editor/model"
require "scripts/states/map_editor/view"
require "scripts/states/map_editor/controller"
require "scripts/states/map_editor/input_delegate"

module ES
  module States
    class MapEditor < Base
      def init
        super
        @screen_rect = Screen.rect.contract(16)

        @model = MapEditorModel.new
        @view = MapEditorView.new @model
        @controller = MapEditorController.new @model, @view
        @inp = MapEditorInputDelegate.new(@controller)
        @inp.register(@input)
        @input.on(:any) { |e| @view.trigger(e) }

        create_world
        create_map

        create_tilemaps

        @grid_underlay = Sprite.new("media/ui/grid_32x32_ff777777.png")
        @grid_overlay  = Sprite.new("media/ui/grid_32x32_ffffffff.png")
        @chunk_borders = Spritesheet.new("media/ui/chunk_outline_3x3.png", 32, 32)

        create_autosave_interval

        tileset = Database.find(:tileset, uri: "/tilesets/common")
        @model.tile_palette.tileset = tileset
        @view.tileset = ES.cache.tileset(tileset.filename,
                                         tileset.cell_width, tileset.cell_height)

        @controller.set_layer(-1)
        @controller.refresh_follow
      end

      def create_world
        @world = World.new
      end

      def create_map
        map = Database.find(:map, uri: "/maps/school/f1")
        @model.map = map.to_editor_map
        @model.map.chunks = map.chunks.map do |chunk_head|
          chunk = Database.find(:chunk, uri: chunk_head.uri)
          editor_chunk = chunk.to_editor_chunk
          editor_chunk.position = chunk_head.position
          editor_chunk.tileset = Database.find(:tileset, uri: chunk.tileset.uri)
          editor_chunk
        end
      end

      def create_tilemaps
        @chunk_renderers = @model.map.chunks.map do |chunk|
          renderer = ChunkRenderer.new(chunk)
          renderer.layer_opacity = @layer_opacity
          renderer
        end
      end

      def create_autosave_interval
        @autosave_interval = @scheduler.every("3m") do
          @controller.autosave
        end.tag("autosave")
      end

      def update_world(delta)
        @world.update(delta)
      end

      def update(delta)
        @controller.update(delta)
        update_world(delta)
        super delta
      end

      def render_map
        pos = -@model.camera.view.floor
        @chunk_renderers.each do |renderer|
          lp = (pos + renderer.position * 32)
          @grid_underlay.clip_rect = Rect.new(0, 0, *(renderer.chunk.bounds.wh*32))
          @grid_underlay.render(*lp)
          renderer.render(*pos)
          if @model.flag_show_chunk_labels
            @chunk_borders.render(*lp, 0)
            @chunk_borders.render(*lp+[@grid_underlay.clip_rect.width-32,0,0], 2)
            @chunk_borders.render(*lp+[0,@grid_underlay.clip_rect.height-32,0], 6)
            @chunk_borders.render(*lp+(@grid_underlay.clip_rect.whd-[32,32,0]), 8)
          end
          #@grid_overlay.clip_rect = Rect.new(0, 0, *@grid_underlay.clip_rect.wh)
          #@grid_overlay.render(*pos)
        end
      end

      def render
        render_map
        @view.render
        super
      end
    end
  end
end
