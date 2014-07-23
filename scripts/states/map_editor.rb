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

        @mode = StateMachine.new
        @mode.on_mode_change = ->(mode){ on_mode_change(mode) }

        @model = MapEditorModel.new
        @view = MapEditorView.new @model
        @controller = MapEditorController.new @model, @view
        @inp = MapEditorInputDelegate.new(@controller)
        @inp.register(@input)

        create_world
        create_map

        create_tilemaps

        @grid_underlay = Sprite.new("media/ui/grid_32x32_ff777777.png")
        @grid_overlay  = Sprite.new("media/ui/grid_32x32_ffffffff.png")
        @chunk_borders = Spritesheet.new("media/ui/chunk_outline_3x3.png", 32, 32)
        @mode_icon = ModeIcon.new({
          view: "film",
          edit: "gear",
          help: "book",
          show_chunk_labels: "search",
          debug_shell: "dashboard"
        })

        @mode_icon.position.set(Rect.new(0, 0, 32, 32).align("bottom right", @screen_rect).xyz)
        @mode_icon.color = Vector4.new(1, 1, 1, 1)

        create_autosave_interval

        tileset = Database.find(:tileset, uri: "/tilesets/common")
        @model.tile_palette.tileset = tileset
        @view.tileset = ES.cache.tileset(tileset.filename,
                                         tileset.cell_width, tileset.cell_height)

        @controller.set_layer(-1)
        @controller.refresh_follow
        @mode.push :view
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

      def switch_mode_icon(mode)
        time = "150"
        fade_color = Vector4.new(0, 0, 0, 0)
        base_color = Vector4.new(1, 1, 1, 1)

        @scheduler.remove(@mode_icon_job)
        @mode_icon_job = @scheduler.in time do
          add_transition @mode_icon.color, base_color, time do |value|
            @mode_icon.color = value
          end
          @mode_icon.mode = mode
        end

        remove_transition(@mode_icon_transition)
        @mode_icon_transition = add_transition @mode_icon.color, fade_color, time do |value|
          @mode_icon.color = value
        end
      end

      def on_mode_change(mode)
        switch_mode_icon(mode)
      end

      def update_world(delta)
        return if @mode.is? :help
        @world.update(delta)
      end

      def update(delta)
        @view.update(delta)
        @controller.update(delta)

        if @mode.has?(:edit)
          @controller.update_edit_mode(delta)
        end
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
          if @mode.is? :show_chunk_labels
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
        if @mode.is? :help
          @view.render_help_mode
        elsif @mode.has? :edit
          @view.render_edit_mode
        end
        @mode_icon.render
        super
      end
    end
  end
end
