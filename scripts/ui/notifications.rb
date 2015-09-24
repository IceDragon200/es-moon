require 'scripts/ui/animated_text'

module UI
  class Notifications < AnimatedText
    # @return [Proc] a proc which takes a string and returns a string
    attr_accessor :formatter

    def initialize(*args, &block)
      @time = 1.0
      @duration = 1.0
      @formatter = ->(s) { s }
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
      options[:string] = @formatter.call(options[:string])
      set options
      arm options.fetch(:duration, 0.50)
    end
  end
end
