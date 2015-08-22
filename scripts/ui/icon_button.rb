module ES
  module UI
    class IconButton < Moon::RenderContext
      include Moon::Activatable

      attr_accessor :active
      attr_accessor :icon_sprite
      attr_accessor :icon_sprite_active

      def initialize_content
        super
        @active = false
        @icon_sprite = nil
        @icon_sprite_active = nil
        @label_text = Moon::Label.new '', ES.game.font_cache.font('system', 16)
      end

      def color
        @icon_sprite.color
      end

      def color=(color)
        @icon_sprite.color = color
      end

      def label
        @label_text.string
      end

      def label=(label)
        @label_text.string = label
      end

      def w
        @icon_sprite.w
      end

      def h
        @icon_sprite.h
      end

      def render_content(x, y, z, options)
        if active? && @icon_sprite_active
          @icon_sprite_active.render x, y, z
        else
          @icon_sprite.render x, y, z
        end
        @label_text.render x, y + h, z
      end
    end
  end
end
