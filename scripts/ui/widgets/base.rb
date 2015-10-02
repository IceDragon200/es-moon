require 'scripts/ui/widgets/events'

module UI
  module Widgets
    class Base < Moon::RenderContainer
      attr_accessor :handle

      protected def initialize_from_options(options)
        super
        @handle = options[:handle]
      end

      def ui_texture
        Game.instance.textures['ui/uikit']
      end
    end
  end
end
