module ES
  module UI
    class AnimatedText < Moon::Text
      attr_accessor :target_text

      def arm(duration)
        show
        @time = 0
        @duration = duration
        @target_string = string.dup
        self
      end

      def finish
        @time = @duration
        self.string = @target_string.dup
        self
      end

      def done?
        @time >= @duration
      end

      def update(delta)
        return if done?
        if @string
          @time += delta
          @time = @duration if @time > @duration
          self.string = @target_string[0, ((@time / @duration) * @target_string.size).to_i]
        end
        self
      end
    end

    class Notifications < AnimatedText
      def initialize(*args, &block)
        @time = 1.0
        @duration = 1.0
        super
      end

      # @return [self]
      def clear
        self.string = nil
        arm(1.0).finish
        self
      end

      # @param [Hash] options
      #   @option [Sftring] string
      #   @option [Float] duration  in seconds
      #   @option [Font] font
      #     @optional
      #   @option [Symbol] align
      #     @optional
      # @return [self]
      def notify(options)
        set options
        arm options.fetch(:duration, 0.50)
      end
    end
  end
end
