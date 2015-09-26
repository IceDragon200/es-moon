require 'scripts/models/map'
require 'scripts/ui/text_list'

module UI
  class MapList < TextList
    class MapSelectedEvent < Moon::Event
      attr_accessor :map

      # @param [Models::Map]
      def initialize(map)
        @map = map
        super :map_selected
      end
    end

    protected def initialize_content
      super
      @background = Renderers::Windowskin.new texture: Game.instance.textures['ui/windowskin_help_panel']
      @background.position -= [8, 8, 0]
    end

    protected def initialize_events
      super
      on :resize do |e|
        @background.resize(w + 16, h + 16)
      end

      on :index do |e|
        if item = current_item
          on_map_select item[:map]
        end
      end
    end

    # Call this method to regenerate the map list
    #
    # @return [self]
    def refresh_list
      clear_elements
      Game.instance.database.each_pair do |_, map|
        next unless Models::Map === map
        add_entry :map,
          name: "#{map.id} - #{map.name}",
          map: map,
          enabled: true
      end
      self
    end

    # @param [Models::Map] map
    private def on_map_select(map)
      trigger { MapSelectedEvent.new(map) }
    end

    def render_content(x, y, z, options)
      @background.render x, y, z
      super
    end
  end
end
