require 'scripts/renderers/camera_context'

module States
  class Map < Base
    def init
      super
      @game = cvar['game']

      r = screen.rect.translatef(-0.5, -0.5).scale(0.5, 0.5)
      @camera = Camera2.new view: r

      @view = MapView.new
      @view.dm_map = @game.map

      ctx = CameraContext.new
      ctx.camera = @camera
      ctx.add @view

      @renderer.add ctx
    end
  end
end
