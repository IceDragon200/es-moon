module UI
  class IconButton < Moon::RenderContext
    include Moon::Activatable

    attr_accessor :active
    attr_accessor :icon_sprite
    attr_accessor :icon_sprite_active

    protected def initialize_content
      super
      @active = false
      @icon_sprite = nil
      @icon_sprite_active = nil
      @label_text = Moon::Label.new '', Game.instance.fonts['system.16']
    end

    # @return [Moon::Vector4]
    def color
      @icon_sprite.color
    end

    # @param [Moon::Vector4] color
    def color=(color)
      @icon_sprite.color = color
    end

    # @return [String] label
    def label
      @label_text.string
    end

    # @param [String] label
    def label=(label)
      @label_text.string = label
    end

    # @return [Integer]
    def w
      @icon_sprite.w
    end

    # @return [Integer]
    def h
      @icon_sprite.h
    end

    # @param [Integer] x
    # @param [Integer] y
    # @param [Integer] z
    # @param [Hash] options
    protected def render_content(x, y, z, options)
      if active? && @icon_sprite_active
        @icon_sprite_active.render x, y, z
      else
        @icon_sprite.render x, y, z
      end
      @label_text.render x, y + h, z
    end
  end
end
