module ES
  module UI
    class AwesomeButton < Moon::RenderContext
      attr_reader :text

      def initialize
        super
        @text = Moon::Text.new '', FontCache.font('awesome', 32)
      end

      def w
        32
      end

      def h
        32
      end

      def render_content(x, y, z, options)
        return unless @text.string.presence
        @text.render x + (w - @text.font.size) / 2,
                     y + (h - @text.font.size) / 2,
                     z
        super
      end

    end
  end
end
