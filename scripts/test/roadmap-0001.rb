module Roadmap
  class StateDisplaySpriteOnScreen < State
    def init
      super
      @sprite = Sprite.new("media/blocks/b032x032.png")
      @sprite.clip_rect = Rect.new(96, 0, 32, 32)
      @sprite.ox, @sprite.oy = @sprite.width/2, @sprite.height/2
      @container = @sprite.containerize
    end

    def update(delta)
      super delta
      @sprite.angle += delta * 180
    end

    def render
      super
      @container.render(Screen.width/2, Screen.height/2, 0)
    end
  end
end
