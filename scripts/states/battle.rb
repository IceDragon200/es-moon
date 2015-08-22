require 'scripts/adapters/entity_position_adapter'
require 'scripts/renderers/camera_context'
require 'scripts/renderers/map_view'
require 'scripts/ui/wait_time_list'

module States
  class Battle < Base
    def create_game_world
      @game = cvar['game']
      @game.world = ES::EntitySystem::World.new
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
      rounds_text = Moon::Label.new '', FontCache.font('system', 16)
      rounds_text.tag 'rounds'
      scheduler.run do
        t = @tactics[:tactics]
        str = ''
        t.each_pair do |key, value|
          if key == :phase
            value = Enum::PHASE_NAME.fetch(value).titleize
          end
          str << "#{key.to_s.camelize}: #{value}\n"
        end
        rounds_text.position.set(8, screen.h - 24 * (t.each_field.count + 1) - 8, 0)
        rounds_text.string = str
      end
      @gui.add rounds_text
    end

    def create_wait_time_list
      wait_time_list = UI::WaitTimeList.new
      wait_time_list.world = @game.world
      wait_time_list.position.set(8, 8, 0)
      @gui.add wait_time_list
    end

    def init
      super
      create_game_world
      create_camera
      create_view
      create_rounds_text
      create_wait_time_list
    end

    def register_input_events
      input.on [:press, :repeat] do |ev|
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
               wait_time: { value: 500, max: 500 + rand(160) },
               actions: { },
               action_points: { value: 10, max: 10 },
               name: { string: 'Player' },
               team: { number: Enum::Team::ALLY },
               health: { value: 20, max: 20 },
               sprite: { filename: 'characters/3x/characters_3x.png',
                         clip_rect: Moon::Rect.new(72, 24, 24, 24) }
      end

      @game.world.spawn do |en|
        en.add transform: { position: Moon::Vector3.new(-6, 4) },
               wait_time: { value: 500, max: 500 + rand(160) },
               action_points: { value: 10, max: 10 },
               name: { string: 'Enemy' },
               ai: { },
               team: { number: Enum::Team::ENEMY },
               health: { value: 100, max: 10 },
               sprite: { filename: 'characters/3x/characters_3x.png',
                         clip_rect: Moon::Rect.new(72, 144, 24, 24) }
      end
      @camera.follow EntityPositionAdapter.new(@cursor)

      register_input_events
    end

    def update_tactics(delta)
      tactics = @tactics[:tactics]
      if tactics.idle
        case tactics.phase
        when Enum::TacticsPhase::BATTLE_START,
             Enum::TacticsPhase::ROUND_NEXT,
             Enum::TacticsPhase::ROUND_START,
             Enum::TacticsPhase::TURN_START,
             Enum::TacticsPhase::TURN_JUDGE
          tactics.idle = false
        when Enum::TacticsPhase::NEXT_TICK
          if entity = @game.world.get_entity_by_id(tactics.subject_id)
            entity[:sprite].selected = true
          end
          tactics.idle = false
        when Enum::TacticsPhase::TURN_END
          if entity = @game.world.get_entity_by_id(tactics.subject_id)
            entity[:sprite].selected = false
          end
          tactics.idle = false
        when Enum::TacticsPhase::ACTION_NEXT
          tactics.idle = false
        end
      end
    end

    def update(delta)
      super
      update_tactics delta
    end
  end
end
