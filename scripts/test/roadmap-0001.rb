module Roadmap
  class StateDisplaySpriteOnScreen < State
    def init
      super
      @sprite = Sprite.new("media/blocks/b032x032.png")
      @sprite.clip_rect = Rect.new(96, 0, 32, 32)
      @sprite.ox, @sprite.oy = @sprite.w / 2, @sprite.h / 2
      @container = @sprite.containerize
    end

    def update(delta)
      super delta
      @sprite.angle += delta * 180
    end

    def render
      super
      @container.render(screen.w / 2, screen.h / 2, 0)
    end
  end
end
