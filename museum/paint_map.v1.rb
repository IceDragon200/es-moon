# This is here for historical purposes
module ES
  module Helper
    class PaintMap

      VERSION = "1.0.0"

      attr_accessor :layer
      attr_accessor :rect
      attr_accessor :stroke_weight
      attr_accessor :value

      def initialize(data)
        @data = data
        @actions = []
        @stack = []
        @layer = 0
        @rect = Moon::Rect.new(0, 0, @data.xsize, @data.ysize)
        @stroke_weight = 1
        @value = 0
      end

      def pos
        @rect.xy
      end

      def size
        @rect.wh
      end

      def reset_pos
        @rect.xy = [0, 0]
      end

      def reset_size
        @rect.wh = [@data.xsize, @data.ysize]
      end

      def reset_rect
        @rect.set(0, 0, @data.xsize, @data.ysize)
      end

      def set_layer(n)
        @layer = n
        self
      end

      def set_pos(*args)
        if args.size == 1
          @rect.xy, = args
        else
          @rect.xy = args
        end
        self
      end

      def set_size(*args)
        if args.size == 1
          @rect.wh, = args
        else
          @rect.wh = args
        end
      end

      def set_rect(*args)
        if args.size == 1
          @rect.set(args[0])
        else
          @rect.set(*args)
        end
        self
      end

      def set_stroke_weight(n)
        @stroke_weight = n
        self
      end

      def set_value(n)
        @value = n
        self
      end

      def snapshot
        {
          layer: @layer,
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

      def point
        @actions << snapshot.merge(action: :point)
        self
      end

      def move(x, y)
        @rect.xy += [x, y]
        self
      end

      def render
        for action in @actions
          rect   = action[:rect]
          layer  = action[:layer]
          value  = action[:value]

          case action[:action]
          when :point
            @data[rect.x, rect.y, layer] = value
          when :fill
            (rect.y...rect.y2).each do |y|
              (rect.x...rect.x2).each do |x|
                @data[x, y, layer] = value
              end
            end
          when :clear
            (rect.y...rect.y2).each do |y|
              (rect.x...rect.x2).each do |x|
                @data[x, y, layer] = -1
              end
            end
          when :stroke
            weight = action[:stroke_weight]

            (rect.w+weight*2).times do |x|
              weight.times do |y|
                dx = rect.x + x - weight
                @data[dx, rect.y-1-y, layer] = value
                @data[dx, rect.y2+y, layer] = value
              end
            end

            weight.times do |x|
              (rect.h+weight*2).times do |y|
                dy = rect.y + y - weight
                @data[rect.x-1-x, dy, layer] = value
                @data[rect.x2+x,  dy, layer] = value
              end
            end

          end
        end
        self
      end

      alias :resize :set_size
      alias :size= :set_size
      alias :pos= :set_pos

    end
  end
end