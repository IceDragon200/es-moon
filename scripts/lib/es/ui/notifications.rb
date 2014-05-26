module ES
  module UI
    class AnimatedText < Text

      include Visibility

      attr_accessor :target_text

      def arm(duration)
        show
        @time = 0
        @duration = duration
        @target_string = @string
        self
      end

      def finish
        @time = @duration
        @string = @target_string
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
          @string = @target_string[0, ((@time / @duration) * @target_string.size).to_i]
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

      def clear
        self.string = nil
        arm(1.0).finish
        self
      end

      ###
      # @param [Hash] options
      #   @option [Sftring] string
      #   @option [Float] duration  in seconds
      #   @option [Font] font
      #     @optional
      #   @option [Symbol] align
      #     @optional
      ###
      def notify(options)
        set options
        arm options.fetch(:duration, 0.25)
      end

    end
  end
end