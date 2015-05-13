class ModeIcon < Moon::RenderContainer
  attr_reader :mode

  def initialize(icons)
    super()
    @icons = icons
    @font_awesome = ES.cache.font('awesome', 32)
    @charmap_awesome = ES.cache.charmap('awesome.yml')
    @text = Moon::Text.new('', @font_awesome)

    add(@text)
  end

  def color
    @text.color
  end

  def color=(color)
    @text.color = color
  end

  def mode=(name)
    @mode = name
    @text.string = @charmap_awesome[@icons[@mode]] || ''
  end
end
