require 'scripts/ui/widgets/base'
require 'scripts/renderers/windowskin'

module UI
  module Widgets
    class Panel < Base
      private def create_windowskin
        @windowskin = Renderers::Windowskin.new(texture: ui_texture,
          affects_parent_size: false,
          src_rect: Moon::Rect.new(96 * 4, 32 + 48, 48, 48))
        add @windowskin
      end

      protected def initialize_elements
        super
        create_windowskin
      end

      protected def initialize_events
        super
        on :resize do |e|
          @windowskin.resize(e.parent.w, e.parent.h)
        end
      end
    end
  end
end
