module ES
  module UI
    class AwesomeButton < Moon::RenderContext
      def initialize_content
        super
        @icon_text = Moon::Label.new '', FontCache.font('awesome', 24)
        @label_text = Moon::Label.new '', FontCache.font('system', 16)
      end

      def color
        @icon_text.color
      end

      def color=(color)
        @icon_text.color = color
      end

      def icon
        @icon_text.string
      end

      def icon=(icon)
        @icon_text.string = icon
      end

      def label
        @label_text.string
      end

      def label=(label)
        @label_text.string = label
      end

      def w
        @icon_text.font.size + 8
      end

      def h
        @icon_text.font.size
      end

      def render_content(x, y, z, options)
        tx = x + (w - @icon_text.font.size) / 2
        ty = y + (h - @icon_text.font.size) / 2
        @icon_text.render tx, ty, z
        @label_text.render tx, ty + h, z
      end
    end
  end
end
