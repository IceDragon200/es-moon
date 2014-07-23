require "scripts/states/base/input_context"
require "scripts/states/base/state_model"
require "scripts/states/base/state_view"
require "scripts/states/base/state_controller"
require "scripts/states/base/state_input_delegate"

module ES
  module States
    class Base < State
      include TransitionHost

      @@__cvar__ = {}

      def init
        super
        @input.on :press, :left_bracket do
          @scheduler.p_job_table
        end

        @input.on :press, :backslash do
          if @debug_shell
            stop_debug_shell
          else
            launch_debug_shell
          end
        end

        @input.typing do |e|
          @debug_shell.string += e.char if @debug_shell
        end

        @input.on :press, :backspace do
          @debug_shell.string = @debug_shell.string.chop if @debug_shell
        end

        @input.on :repeat, :backspace do
          @debug_shell.string = @debug_shell.string.chop if @debug_shell
        end

        @input.on :press, :enter do
          @debug_shell.exec if @debug_shell
        end
      end

      def launch_debug_shell
        @debug_shell = DebugShell.new
        @debug_shell.position.set(0, 0, 0)
      end

      def stop_debug_shell
        @debug_shell = nil
      end

      def update(delta)
        super delta
        update_transitions delta
      end

      def cvar
        @@__cvar__
      end

      def render
        @debug_shell.render if @debug_shell
        super
      end
    end
  end
end
