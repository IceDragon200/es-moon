module UI
  class ModeIcon < Moon::RenderContainer
    attr_reader :mode

    # @param [Hash<>] icons
    def initialize(icons)
      super()
      @icons = icons
      @font_awesome = Game.instance.fonts['awesome.32']
      @charmap_awesome = Game.instance.database('charmap/awesome.yml')
      @text = Moon::Label.new('', @font_awesome)

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
end
