module ES
  module Helper
    # Utility class for drawing maps
    class PaintMap
      attr_accessor :layer

      # @param [Moon::DataMatrix] data
      def initialize(data)
        @data = data
        @layer = 0
      end

      def [](*args)
        case args.size
        # [[x, y, z]]= value
        # [vec2]= value
        # [vec3]= value
        when 1
          pos, = *args
          x, y, layer = *pos
          layer ||= @layer
        # [x, y]
        when 2
          layer = @layer
          x, y = *args
        # [x, y, layer]
        when 3
          x, y, layer = *args
        else
          raise ArgumentError,
                "wrong argument count #{args.size} (expected 2, 3, or 4)"
        end
        @data[x, y, layer]
      end

      def []=(*args)
        case args.size
        # [[x, y]]= value
        # [vec2]= value
        # [vec3]= value
        when 2
          pos, value = *args
          x, y, layer = *pos
          layer ||= @layer
        # [x, y] = value
        when 3
          x, y, value = *args
          layer = @layer
        # [x, y, z] = value
        when 4
          x, y, layer, value = *args
        else
          raise ArgumentError,
                "wrong argument count #{args.size} (expected 2, 3, or 4)"
        end
        @data[x, y, layer] = value
      end

      def fill(opts)
        rect  = opts[:rect]
        value = opts.fetch(:value)
        layer = opts.fetch(:layer, @layer)

        if rect
          # so we can support Arrays as well
          rx, ry, rw, rh = *rect
          rx2 = rx + rw
          ry2 = ry + rh
          (ry...ry2).each do |y|
            (rx...rx2).each do |x|
              @data[x, y, layer] = value
            end
          end
        else
          @data.ysize.times do |y|
            @data.xsize.times do |x|
              @data[x, y, layer] = value
            end
          end
        end
        self
      end

      def clear(opts = {})
        fill({ value: -1 }.merge(opts))
        self
      end

      def stroke(opts) # value, weight, rect
        rect   = opts.fetch(:rect)
        weight = opts.fetch(:weight, 1)
        value  = opts.fetch(:value)
        layer  = opts.fetch(:layer, @layer)

        rx, ry, rw, rh = *rect
        rx2 = rx + rw
        ry2 = ry + rh

        weight.times do |w|
          (rw + weight * 2).times do |x|
            dx = rx + x - weight
            @data[dx, ry - 1 - w, layer] = value
            @data[dx, ry2 + w, layer] = value
          end
          (rh + weight * 2).times do |y|
            dy = ry + y - weight
            @data[rx - 1 - w, dy, layer] = value
            @data[rx2 + w,  dy, layer] = value
          end
        end
        self
      end
    end
  end
end
