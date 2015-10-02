require 'scripts/ui/widgets/base'

module UI
  module Widgets
    class Checkbox < Base
      attr_reader :state

      def state=(state)
        @state = state
        @checkbox_sprite.clip_rect = @rects[@state]
      end

      protected def initialize_elements
        super
        @checkbox_sprite = Moon::Sprite.new(ui_texture).to_sprite_context
        @rects = [
          Moon::Rect.new(96 * 4 + 48,  80, 16, 16),
          Moon::Rect.new(96 * 4 + 48,  96, 16, 16),
          Moon::Rect.new(96 * 4 + 48, 112, 16, 16)
        ]
        self.state = 0
        add @checkbox_sprite
      end

      protected def initialize_events
        super
        input.on :click do |e|
          if e.button == :mouse_left
            self.state = @state.succ.modulo(2)
          end
        end
      end
    end
  end
end
