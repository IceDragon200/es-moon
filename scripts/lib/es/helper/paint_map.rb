module ES
  module Helper
    class PaintMap

      attr_accessor :layer
      attr_accessor :pos
      attr_accessor :rect
      attr_accessor :stroke_weight
      attr_accessor :value

      def initialize(data)
        @data = data
        @actions = []
        @stack = []
        @layer = 0
        @pos = Vector2.new
        @rect = Moon::Rect.new(0, 0, data.xsize, data.ysize)
        @stroke_weight = 1
        @value = 0
      end

      def set_layer(n)
        self.layer = n
        self
      end

      def set_pos(n)
        self.pos = n
        self
      end

      def set_rect(n)
        self.rect = n
        self
      end

      def set_stroke_weight(n)
        self.stroke_weight = n
        self
      end

      def set_value(n)
        self.value = n
        self
      end

      def snapshot
        {
          layer: @layer,
          pos: @pos.dup,
          rect: @rect.dup,
          stroke_weight: @stroke_weight,
          value: @value,
        }
      end

      def save
        @stack << snapshot
        if block_given?
          yield self
          load
        end
        self
      end

      def load
        state = @stack.pop
        @layer = state[:layer]
        @pos = state[:pos]
        @rect = state[:rect]
        @stroke_weight = state[:stroke_weight]
        @value = state[:value]
        self
      end

      def clear
        @actions << snapshot.merge(action: :clear)
        self
      end

      def fill
        @actions << snapshot.merge(action: :fill)
        self
      end

      def stroke
        @actions << snapshot.merge(action: :stroke)
        self
      end

      def render
        for action in @actions
          offset = action[:pos]
          rect   = action[:rect]
          layer  = action[:layer]
          value  = action[:value]

          case action[:action]
          when :fill
            (rect.y...rect.y2).each do |y|
              (rect.x...rect.x2).each do |x|
                @data[offset.x + x, offset.y + y, layer] = value
              end
            end
          when :clear
            (rect.y...rect.y2).each do |y|
              (rect.x...rect.x2).each do |x|
                @data[offset.x + x, offset.y + y, layer] = -1
              end
            end
          when :stroke
            weight = action[:stroke_weight]

            (rect.w+weight*2).times do |x|
              weight.times do |y|
                dx = offset.x + rect.x + x - weight
                @data[dx, offset.y + rect.y-1-y, layer] = value
                @data[dx, offset.y + rect.y2+y, layer] = value
              end
            end

            weight.times do |x|
              (rect.h+weight*2).times do |y|
                dy = offset.y + rect.y + y - weight
                @data[offset.x + rect.x-1-x, dy, layer] = value
                @data[offset.x + rect.x2+x,  dy, layer] = value
              end
            end

          end
        end
        self
      end

    end
  end
end