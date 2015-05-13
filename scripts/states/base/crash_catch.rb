class CrashException
  attr_reader :original
  attr_reader :backtrace

  def initialize(org, backtrace)
    @original = org
    @backtrace = backtrace
  end

  def inspect
    @original.inspect
  end
end

module States
  class Base
    def crash_handling(exc)
      cvar['exc'] = exc
      state_manager.clear
      state_manager.push States::Crash
    end

    def step(delta)
      unless @started
        start
        @started = true
      end
      # game logic
      update_step delta
      # rendering
      render_step
      #
      @ticks += 1
    rescue => exc
      STDERR.puts exc.inspect
      exc.backtrace.each do |line|
        STDERR.puts "\t#{line}"
      end
      # for some odd reason, even though the exception is dup-ed, the backtrace
      # can change afterwards.
      crash_handling CrashException.new(exc, exc.backtrace.dup)
    end
  end
end
