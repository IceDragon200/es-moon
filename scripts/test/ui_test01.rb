class StateUITest01 < State
  class SpriteContainer < Moon::RenderContext
    attr_reader :sprite

    def initialize(*args, &block)
      super()
      @sprite = Sprite.new(*args, &block)
    end

    def width
      @sprite.width
    end

    def height
      @sprite.height
    end

    def render_content(x, y, z)
      @sprite.render x, y, z
      super
    end

    def clip_rect
      @sprite.clip_rect
    end

    def clip_rect=(clip_rect)
      @sprite.clip_rect = clip_rect
    end
  end

  def init
    super
    @sprite1 = SpriteContainer.new("resources/blocks/e032x032.png")
    @sprite1.clip_rect = Rect.new(64, 32, 32, 32)
    @sprite2 = SpriteContainer.new("resources/blocks/e032x032.png")
    @sprite2.clip_rect = Rect.new(96, 32, 32, 32)
    @sprite3 = SpriteContainer.new("resources/blocks/e032x032.png")
    @sprite3.clip_rect = Rect.new(64, 64, 32, 32)
    @container = RenderContainer.new.resize(128, 128).move(32, 32)

    container = RenderContainer.new.resize(32, 32).move(12, 12)
    container.add(@sprite1)
    container.on :input do |s, e|
      s.transition("position.y", s.y + 16)
      #s.transition(:y, s.y + 16)
    end
    @container.add(container)
    container = RenderContainer.new.resize(32, 32).move(12+32, 12)
    container.add(@sprite2)
    container.on :input do |s, e|
      s.transition("position.y", s.y + 16)
      #s.transition(:y, s.y + 16)
    end
    @container.add(container)
    container = RenderContainer.new.resize(32, 32).move(12+32*2, 12)
    container.add(@sprite3)
    container.on :input do |s, e|
      s.transition("position.y", s.y + 16)
      #s.transition(:y, s.y + 16)
    end
    @container.add(container)

    @input.on :press, :mouse_left do |e|
      @container.input_trigger e
    end
  end

  def update(delta)
    super(delta)
    @container.update(delta)
  end

  def render
    @container.render
    super
  end
end
