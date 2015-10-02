require 'scripts/ui/widgets/base'

module UI
  module Widgets
    class RadioButton < Base
      attr_reader :state

      def set_state(state)
        @state = state
        @radio_button_sprite.clip_rect = @rects[@state]
      end

      def state=(state)
        set_state(state)
        parent.input_bubble.bubble_event(RadioEvent.new(self)) if parent
      end

      protected def initialize_elements
        super
        @radio_button_sprite = Moon::Sprite.new(ui_texture).to_sprite_context
        @rects = [
          Moon::Rect.new(96 * 4 + 64, 80, 16, 16),
          Moon::Rect.new(96 * 4 + 80, 80, 16, 16)
        ]
        self.state = 0
        add @radio_button_sprite
      end

      protected def initialize_events
        super
        input.on :click do |e|
          if e.button == :mouse_left
            self.state = 1
          end
        end
      end
    end
  end
end
