require 'scripts/ui/widgets/base'

module UI
  module Widgets
    class Button < Base
      attr_accessor :state
      protected def initialize_elements
        super
        @rects = [
          Moon::Rect.new(0,  0, 48, 16),
          Moon::Rect.new(48, 0, 48, 16)
        ]
        @button_skins = @rects.map do |rect|
          Renderers::Windowskin.new(
            texture: ui_texture, src_rect: rect,
            affects_parent_size: false)
        end
        @state = 0
      end

      protected def initialize_events
        super

        input.on [:press, :release] do |e|
          if e.is_a?(Moon::MouseInputEvent)
            case e.action
            when :press
              if screen_bounds.contains?(e.position)
                @state = 1
              else
                @state = 0
              end
            when :release
              @state = 0
            end
          end
        end

        input.on :mousehover do |e|
          if @state == 1 && !e.state
            @state = 0
          end
        end

        on :resize do |e|
          @button_skins.map { |s| s.resize(e.parent.w, e.parent.h) }
        end
      end

      def render_content(x, y, z)
        @button_skins[@state].render(x, y, z)
        super
      end
    end
  end
end
