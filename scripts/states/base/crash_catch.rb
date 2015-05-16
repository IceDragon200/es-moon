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
  class Base < ::State
    def crash_handling(exc)
      cvar['exc'] = exc
      state_manager.clear
      state_manager.push States::Crash
    end

    def on_exception(exc, backtrace)
      STDERR.puts exc.inspect
      backtrace.each do |line|
        STDERR.puts "\t#{line}"
      end
      # for some odd reason, even though the exception is dup-ed, the backtrace
      # can change afterwards.
      crash_handling CrashException.new(exc, backtrace)
    end

    alias :state_step :step
    def step(delta)
      state_step(delta)
    rescue => exc
      on_exception exc, exc.backtrace.dup
    end
  end
end
