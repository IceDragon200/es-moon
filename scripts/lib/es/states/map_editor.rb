module ES
  module States
    class MapEditor < Map

      class ModeStack

        def initialize
          @list = []
        end

        def current
          @list.last
        end

        def push(mode)
          @list.push mode
          puts @list
        end

        def change(mode)
          @list[-1] = mode
          puts @list
        end

        def pop
          @list.pop
          puts @list
        end

        def is?(mode)
          current == mode
        end

        def has?(mode)
          @list.include?(mode)
        end

        def starts_with?(*modes)
          modes.each_with_index.all? do |mode, i|
            @list[i] == mode
          end
        end

        def trace?(modes)
          @list == modes
        end

        def [](index)
          @list[index]
        end

      end

      class InputContext

        def initialize(input, &block)
          @input = input
          @wrap_function = block
        end

        def on(*args, &block)
          @wrap_function.call @input, *args, &block
        end

      end

      class CamCursor

        attr_accessor :position
        attr_accessor :velocity

        def initialize
          @position = Vector3.new
          @velocity = Vector3.new
        end

        def update(delta)
          @position += @velocity * delta
        end

      end

      def init
        super
        @mouse = Moon::Input::Mouse

        @cam_cursor = CamCursor.new

        @cursor_position = Vector3.new
        @cursor_position_map_pos = Vector3.new

        @hud = RenderLayer.new

        @help_panel       = ES::UI::MapEditorHelpPanel.new

        @dashboard        = ES::UI::MapEditorDashboard.new
        @layer_view       = ES::UI::MapEditorLayerView.new
        @tile_info        = ES::UI::TileInfo.new
        @tile_panel       = ES::UI::TilePanel.new
        @tile_preview     = ES::UI::TilePreview.new

        @ui_posmon        = ES::UI::PositionMonitor.new
        @ui_camera_posmon = ES::UI::PositionMonitor.new

        @tileselection_rect = ES::UI::SelectionTileRect.new

        @cursor_ss  = Cache.block "e032x032.png", 32, 32
        @passage_ss = Cache.block "passage_blocks.png", 32, 32

        @font = Cache.font "uni0553", 16

        @tile_preview.tileset = @tileset

        @tile_info.map = @map
        @tile_info.tileset = @tileset

        @tile_panel.tileset = @tileset

        color = Vector4.new 0.1059, 0.6314, 0.8863, 1.0000
        color += color
        @tileselection_rect.spritesheet = @cursor_ss
        @tileselection_rect.color.set color

        @dashboard.position.set 0, 0, 0
        @tile_info.position.set 0, @dashboard.y2 + 16, 0
        @tile_preview.position.set Screen.width - @tile_preview.width, @dashboard.y2, 0
        @tile_panel.position.set 0, Screen.height - 32 * @tile_panel.visible_rows - 16, 0
        @layer_view.position.set @tile_preview.x, @tile_preview.y2, 0

        @dashboard.show
        @tile_panel.hide

        @hud.add @dashboard
        @hud.add @layer_view
        @hud.add @tile_info
        @hud.add @tile_panel
        @hud.add @tile_preview
        @hud.add @ui_camera_posmon
        @hud.add @ui_posmon


        create_passage_layer

        @ui_posmon.obj = @entity
        @ui_camera_posmon.obj = @camera

        @layer_opacity = [1.0, 1.0]
        @layer_count = @layer_opacity.size

        @mode = ModeStack.new
        @mode.push :view

        set_layer(-1)

        register_events
      end

      def create_tilemaps
        super
        @tilemaps.each { |t| t.layer_opacity = @layer_opacity }
      end

      def create_passage_layer
        @passage_tilemap = Tilemap.new do |tilemap|
          tilemap.position.set 0, 0, 0
          tilemap.tileset = @passage_ss
          tilemap.data = @passage_data # special case passage data
        end
      end

      def set_layer(layer)
        @layer = layer
        @layer_view.index = @layer
        if @layer < 0
          @layer_opacity.map! { 1.0 }
        else
          @layer_opacity.map! { 0.3 }
          @layer_opacity[@layer] = 1.0
        end
      end

      def modespace(mode)
        @_wrappers ||= []
        (@_modes ||=[]).push mode
        modes = @_modes.dup

        wrapper = InputContext.new(@input) do |i, *a, &b|
          i.on(*a) { |*a2, &b2| b.call(*a2, &b2) if @mode.trace?(modes) }
        end
        #wrapper = InputContext.new(@_wrappers.last||@input) do |i, *a, &b|
        #  i.on(*a) { |*a2, &b2| b.call(*a2, &b2) if @mode.trace?(modes) }
        #end

        @_wrappers.push wrapper

        yield @_wrappers.last

        @_wrappers.pop
        @_modes = @_modes.slice 0, @_modes.size-1
      end

      def register_actor_move
        @cam_move_speed = 8
        @input.on :press, Moon::Input::LEFT do
          @cam_cursor.velocity.x = -1 * @cam_move_speed if @mode.starts_with? :edit
        end
        @input.on :press, Moon::Input::RIGHT do
          @cam_cursor.velocity.x = 1 * @cam_move_speed if @mode.starts_with? :edit
        end
        @input.on :release, Moon::Input::LEFT, Moon::Input::RIGHT do
          @cam_cursor.velocity.x = 0 if @mode.starts_with? :edit
        end

        @input.on :press, Moon::Input::UP do
          @cam_cursor.velocity.y = -1 * @cam_move_speed if @mode.starts_with? :edit
        end
        @input.on :press, Moon::Input::DOWN do
          @cam_cursor.velocity.y = 1 * @cam_move_speed if @mode.starts_with? :edit
        end
        @input.on :release, Moon::Input::UP, Moon::Input::DOWN do
          @cam_cursor.velocity.y = 0 if @mode.starts_with? :edit
        end
      end

      def register_events
        modespace :edit do |input|
          ## copy tile
          input.on :press, Moon::Input::MOUSE_MIDDLE do
            copy_tile
          end

          ## erase tile
          input.on :press, Moon::Input::MOUSE_RIGHT do
            erase_tile
          end

          ## help
          input.on :press, Moon::Input::F1 do
            @dashboard.enable 0
            @mode.push :help
          end

          modespace :help do |inp2|
            inp2.on :release, Moon::Input::F1 do
              @dashboard.disable 0
              @mode.pop
            end
          end

          ## New Map
          input.on :press, Moon::Input::F2 do
            @dashboard.enable 1
            @mode.push :create_map
          end

          modespace :create_map do |inp2|
            inp2.on :release, Moon::Input::F2 do
              @dashboard.disable 1
              @mode.pop
            end
          end

          ## New Chunk
          input.on :press, Moon::Input::F3 do
            @dashboard.enable 2
            @mode.push :create_chunk
            @selection_stage = 1
          end

          ## Show Chunk Labels
          input.on :press, Moon::Input::F10 do
            @dashboard.enable 9
            @mode.push :show_chunk_labels
            @tile_info.hide
          end

          modespace :show_chunk_labels do |inp2|
            inp2.on :release, Moon::Input::F10 do
              @dashboard.disable 9
              @tile_info.show
              @mode.pop
            end
          end

          @selection_stage = 0
          modespace :create_chunk do |inp2|
            inp2.on :press, Moon::Input::MOUSE_LEFT do
              if @selection_stage == 1
                @tileselection_rect.tile_rect.xyz = @cursor_position_map_pos

                @tileselection_rect.activate
                @selection_stage += 1
              elsif @selection_stage == 2
                @tileselection_rect.tile_rect.whd = @cursor_position_map_pos - @tileselection_rect.tile_rect.xyz

                id = @map.chunks.size+1
                create_chunk @tileselection_rect.tile_rect, id: id, name: "new/chunk-#{id}"
                create_tilemaps

                @selection_stage = 0
                @tileselection_rect.deactivate
                @dashboard.disable 2
                @mode.pop
              end
            end
            inp2.on :press, Moon::Input::MOUSE_RIGHT do
              if @selection_stage == 1
                @selection_stage = 0
                @dashboard.disable 2
                @mode.pop
              elsif @selection_stage == 2
                @selection_stage -= 1
                @tileselection_rect.deactivate
              end
            end
          end

          ## tile panel
          input.on :press, Moon::Input::TAB do
            @mode.push :tile_select
            @tile_panel.show
            @tile_preview.hide
          end

          modespace :tile_select do |inp2|
            inp2.on :release, Moon::Input::TAB do
              @mode.pop
              @tile_panel.hide
              @tile_preview.show
            end
            inp2.on :press, Moon::Input::MOUSE_LEFT do
              @tile_panel.select_tile(@mouse.pos-[0,16])
            end
          end

          input.on :press, Moon::Input::MOUSE_LEFT do
            place_tile(@tile_panel.tile_id)
          end

          ## multi function
          modespace :dashboard do |inp2|
            inp2.on :press, Moon::Input::MOUSE_LEFT do
              ## interact
              pos = Moon::Input::Mouse.pos
              if @dashboard.pos_inside?(pos)
                @dashboard.trigger Input::MouseEvent.new(:click, pos)
              end
            end
          end

          input.on :press, Moon::Input::V do
            @mode.change :view
            @camera.follow @entity
            @ui_posmon.obj = @entity
          end

          ## layer toggle
          input.on :press, Moon::Input::N0 do
            set_layer(-1)
          end
          input.on :press, Moon::Input::N1 do
            set_layer(0)
          end
          input.on :press, Moon::Input::N2 do
            set_layer(1)
          end
        end
        modespace :view do |input|
          ## mode toggle
          input.on :press, Moon::Input::E do
            @camera.follow @cam_cursor
            @ui_posmon.obj = @cam_cursor
            @mode.change :edit
          end

          input.on :press, Moon::Input::LEFT do
            @entity.velocity.x = -1 * @entity.move_speed
          end
          input.on :press, Moon::Input::RIGHT do
            @entity.velocity.x = 1 * @entity.move_speed
          end
          input.on :release, Moon::Input::LEFT, Moon::Input::RIGHT do
            @entity.velocity.x = 0
          end

          input.on :press, Moon::Input::UP do
            @entity.velocity.y = -1 * @entity.move_speed
          end
          input.on :press, Moon::Input::DOWN do
            @entity.velocity.y = 1 * @entity.move_speed
          end
          input.on :release, Moon::Input::UP, Moon::Input::DOWN do
            @entity.velocity.y = 0
          end
        end
      end

      ###
      # @param [Vector3] screen_pos
      ###
      def screen_pos_to_map_pos(screen_pos)
        (screen_pos + @camera.view.floor) / 32
      end

      def map_pos_to_screen_pos(map_pos)
        map_pos * 32 - @camera.view.floor
      end

      def screen_pos_map_reduce(screen_pos)
        screen_pos_to_map_pos(screen_pos).floor * 32 - @camera.view.floor
      end

      def place_tile(tile_id)
        info = @tile_info.info
        if chunk = info[:chunk]
          dx, dy, _ = *info[:chunk_data_position]
          chunk.data[dx, dy, @layer] = tile_id
        end
      end

      def copy_tile
        data = @tile_info.info[:data]
        tile_id = data.reject { |n| n == -1 }.last || -1
        @tile_panel.tile_id = tile_id
      end

      def erase_tile
        place_tile(-1)
      end

      def create_chunk(rect, data)
        size = Vector3.new(*rect.wh, 2)

        data[:data] = begin
          dm = DataMatrix.new(*size, default: -1)
          dm
        end
        data[:flags] = begin
          dm = DataMatrix.new(*size)
          dm
        end
        data[:passages] = Table.new(*size.xy)

        dchunk = ES::DataModel::Chunk.new data

        chunk = ES::GameObject::Chunk.new
        chunk.setup(dchunk)

        @map.chunks << chunk
        chunk_p = @map.dmap.chunk_position
        chunk_p[chunk_p.size] = rect.xyz
        @map.refresh
      end

      def update_edit_mode(delta)
        if @mode.starts_with? :edit
          mp = @mouse.pos.xyz
          @cursor_position_map_pos = screen_pos_to_map_pos mp
          @tile_info.tile_position.set @cursor_position_map_pos.xy
          @cursor_position.set screen_pos_map_reduce(mp)
        end

        @hud.update delta
        @tile_preview.tile_id = @tile_panel.tile_id
      end

      def update_map(delta)
        return if @mode.is? :help
        super delta
      end

      def update(delta)
        @cam_cursor.update delta
        if @mode.has? :edit
          update_edit_mode delta
        end

        h = Moon::Screen.height
        w = Moon::Screen.width
        @ui_posmon.position.set((w - @ui_posmon.width - 48), 0, 0)
        @ui_camera_posmon.position.set((w - @ui_camera_posmon.width) / 2,
                                        h - @ui_camera_posmon.height,
                                        0)

        if @tileselection_rect.active?
          @tileselection_rect.position.set map_pos_to_screen_pos(@tileselection_rect.tile_rect.xyz)

          if @selection_stage == 2
            @tileselection_rect.tile_rect.whd = @cursor_position_map_pos - @tileselection_rect.tile_rect.xyz
          end
        end

        super delta
      end

      def render_edit_mode
        @cursor_ss.render(*(@cursor_position+[0, 0, 0]), 1)
        @tileselection_rect.render 0, 0, 0 if @tileselection_rect.active?
        if @mode.is? :show_chunk_labels
          color = Vector4::WHITE
          oy = @font.size
          @map.chunks.each do |chunk|
            x, y, z = *map_pos_to_screen_pos(chunk.position)
            @font.render x, y-oy, z, chunk.name, color, outline: 0
          end
        end
        @hud.render
      end

      def render
        super
        if @mode.is? :help
          @help_panel.render
        elsif @mode.has? :edit
          render_edit_mode
        end
      end

    end
  end
end