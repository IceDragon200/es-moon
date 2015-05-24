require 'scripts/adapters/entity_position_adapter'
require 'scripts/renderers/camera_context'
require 'scripts/renderers/map_view'

module States
  class Map < Base
    def init
      super
      @game = cvar['game']
      @game.world = ES::World.new
      @game.world.register :movement
      @game.world.register :thinks

      r = screen.rect.translatef(-0.5, -0.5)
      @camera = Camera2.new view: r

      @view = MapView.new
      @view.dm_map = @game.map

      @game.world.on :any do |e|
        @view.trigger e
      end

      ctx = CameraContext.new
      ctx.camera = @camera
      ctx.add @view

      @update_list << @camera
      @renderer.add ctx
    end

    def start
      super

      e = @game.world.spawn do |en|
        en.add transform: { position: Moon::Vector3.new },
               sprite: { filename: 'characters/3x/characters_3x.png',
                         clip_rect: Moon::Rect.new(72, 24, 24, 24) }
      end
      @camera.follow(EntityPositionAdapter.new(e))

      input.on :press, :repeat do |ev|
        trns = e[:transform]
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
