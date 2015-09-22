module UI
  class AwesomeButton < Moon::RenderContext
    private def initialize_content
      super
      @icon_text = Moon::Label.new '', Game.instance.fonts['awesome.24']
      @label_text = Moon::Label.new '', Game.instance.fonts['system.16']
    end

    # @return [Moon::Vector4]
    def color
      @icon_text.color
    end

    # @param [Moon::Vector4] color
    def color=(color)
      @icon_text.color = color
    end

    # @return [String]
    def icon
      @icon_text.string
    end

    # @param [String] icon
    def icon=(icon)
      @icon_text.string = icon
    end

    # @return [String]
    def label
      @label_text.string
    end

    # @param [String] label
    def label=(label)
      @label_text.string = label
    end

    # @return [Integer]
    def w
      @icon_text.font.size + 8
    end

    # @return [Integer]
    def h
      @icon_text.font.size
    end

    # @param [Integer] x
    # @param [Integer] y
    # @param [Integer] z
    # @param [Hash] options
    def render_content(x, y, z, options)
      tx = x + (w - @icon_text.font.size) / 2
      ty = y + (h - @icon_text.font.size) / 2
      @icon_text.render tx, ty, z
      @label_text.render tx, ty + h, z
    end
  end
end
