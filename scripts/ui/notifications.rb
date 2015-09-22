require 'scripts/ui/animated_text'

module ES
  module UI
    class Notifications < AnimatedText
      def initialize(*args, &block)
        @time = 1.0
        @duration = 1.0
        super '', Game.instance.fonts['system.16']
      end

      # @return [self]
      def clear
        self.string = ''
        arm(1.0).finish
        self
      end

      # @param [Hash] options
      #   @option [String] string
      #   @option [Float] duration  in seconds
      #   @option [Font] font
      #     @optional
      #   @option [Symbol] align
      #     @optional
      # @return [self]
      def notify(options)
        options = { string: options } if options.is_a?(String)
        set options
        arm options.fetch(:duration, 0.50)
      end
    end
  end
end
