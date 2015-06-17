require 'scripts/adapters/entity_position_adapter'
require 'scripts/renderers/camera_context'
require 'scripts/renderers/map_view'

module States
  class Map < Base
    def init
      super
      create_game_world
      create_camera
      create_view
      create_rounds_text
    end

    def create_game_world
      @game = cvar['game']
      @game.world = ES::World.new
      @game.world.register :tactics
      @game.world.register :actions
      @game.world.register :thinks
      @game.world.register :movement

      @update_list << @game.world
    end

    def create_camera
      r = screen.rect.translatef(-0.5, -0.5)
      @camera = Camera2.new view: r
    end

    def create_view
      @view = MapView.new
      @view.dm_map = @game.map

      @game.world.on :any do |ev|
        @view.trigger ev
      end

      ctx = CameraContext.new
      ctx.camera = @camera
      ctx.add @view

      @update_list << @camera
      @renderer.add ctx
    end

    def create_rounds_text
      rounds_text = Moon::Text.new '', FontCache.font('system', 16)
      rounds_text.tag 'rounds'
      scheduler.run do
        t = @tactics[:tactics]
        rounds_text.string = "Round: #{t.rounds}\nPhase: #{t.phase}\nRoundWT: #{t.round_wt}"
      end
      @gui.add rounds_text
    end

    def start
      super
      @tactics = @game.world.spawn do |en|
        en.add tactics: { phase: Enum::TacticsPhase::BATTLE_START }
      end

      @cursor = @game.world.spawn do |en|
        en.add transform: { position: Moon::Vector3.new(3, 3, 0) },
               sprite: { filename: 'ui/map_editor_cursor_32x32_ffffffff.png' }
      end

      @player = @game.world.spawn do |en|
        en.add transform: { position: Moon::Vector3.new(3, 3, 0) },
               wait_time: { value: 500, max: 500 },
               action_points: { value: 10, max: 10 },
               team: { number: Enum::Team::ALLY },
               health: { value: 20, max: 20 },
               sprite: { filename: 'characters/3x/characters_3x.png',
                         clip_rect: Moon::Rect.new(72, 24, 24, 24) }
      end

      @game.world.spawn do |en|
        en.add transform: { position: Moon::Vector3.new(-6, 4) },
               wait_time: { value: 530, max: 530 },
               action_points: { value: 10, max: 10 },
               team: { number: Enum::Team::ENEMY },
               health: { value: 100, max: 10 },
               sprite: { filename: 'characters/3x/characters_3x.png',
                         clip_rect: Moon::Rect.new(72, 144, 24, 24) }
      end
      @camera.follow EntityPositionAdapter.new(@cursor)

      register_input_events
    end

    def register_input_events
      input.on :press, :repeat do |ev|
        trns = @cursor[:transform]
        case ev.key
        when :left
          trns.position += [-1, 0, 0]
        when :right
          trns.position += [1, 0, 0]
        when :up
          trns.position += [0, -1, 0]
        when :down
          trns.position += [0, 1, 0]
        end
      end
    end
  end
end
