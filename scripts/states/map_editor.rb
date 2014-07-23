require "scripts/states/map_editor/model"
require "scripts/states/map_editor/view"
require "scripts/states/map_editor/controller"
require "scripts/states/map_editor/input_delegate"

module ES
  module States
    class MapEditor < Base
      attr_reader :model
      attr_reader :controller
      attr_reader :view

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
        create_autosave_interval

        tileset = Database.find(:tileset, uri: "/tilesets/common")
        @model.tile_palette.tileset = tileset
        @view.tileset = ES.cache.tileset(tileset.filename,
                                         tileset.cell_width, tileset.cell_height)

        @controller.set_layer(-1)
        @controller.refresh_follow

        @controller.post_init
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

      def render
        @view.render
        super
      end
    end
  end
end
