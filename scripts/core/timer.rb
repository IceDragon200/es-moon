module Moon
  class Timer
    include Moon::Activatable

    # @return [Float]
    attr_reader :time
    # @return [Float]
    attr_reader :duration

    # @param [Hash<Symbol, Object>] options
    # @option options [Float, String] :duration
    # @option options [Boolean] :active
    def initialize(options = {})
      duration = Moon::TimeUtil.to_duration(options.fetch(:duration, 1.0))
      @time = @duration = duration
      @active = options.fetch(:active, true)
    end

    def rate
      @time / @duration.to_f
    end

    def done?
      @time <= 0.0
    end

    def update(delta)
      return unless @active
      return if done?
      @time -= delta
    end

    def restart
      @time = @duration
    end

    def finish
      @time = 0.0
    end
  end
end
