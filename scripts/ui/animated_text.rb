module ES
  module UI
    class AnimatedText < Moon::Label
      attr_reader :timer
      attr_accessor :target_text

      def arm(duration)
        show
        @timer = Moon::Timer.new duration
        @target_string = string.dup
        self
      end

      def finish
        @time = @duration
        self.string = @target_string.dup
        self
      end

      def rate
        1 - @timer.rate
      end

      def done?
        @timer.done?
      end

      def update(delta)
        return if done?
        @timer.update(delta)
        if @target_string
          self.string = @target_string[0, (rate * @target_string.size).to_i]
        end
        self
      end
    end
  end
end
