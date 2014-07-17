module ES
  module Helper
    class PaintMap
      VERSION = "2.0.0"

      attr_accessor :layer

      def initialize(data)
        @data = data
        @layer = 0
      end

      def [](*args)
        @data[*args]
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

      def clear(opts={})
        fill({value: -1}.merge(opts))
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

        (rw+weight*2).times do |x|
          weight.times do |y|
            dx = rx + x - weight
            @data[dx, ry-1-y, layer] = value
            @data[dx, ry2+y, layer] = value
          end
        end
        weight.times do |x|
          (rh+weight*2).times do |y|
            dy = ry + y - weight
            @data[rx-1-x, dy, layer] = value
            @data[rx2+x,  dy, layer] = value
          end
        end
        self
      end
    end
  end
end
