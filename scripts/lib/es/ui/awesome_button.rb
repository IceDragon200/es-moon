module ES
  module UI
    class AwesomeButton < RenderContainer

      attr_reader :text

      def initialize
        super
        @text = Text.new "", ES.cache.font("awesome", 32)
      end

      def width
        32
      end

      def height
        32
      end

      def render(x=0, y=0, z=0)
        return if @text.string.empty?
        px, py, pz = *(@position + [x, y, z])
        @text.render px + (width-@text.font.size)/2,
                     py + (height-@text.font.size)/2,
                     pz
        super x, y, z
      end

    end
  end
end
