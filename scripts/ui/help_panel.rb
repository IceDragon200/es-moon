require 'scripts/renderers/windowskin'

module UI
  class MapEditorHelpPanel < Moon::RenderContainer
    attr_accessor :controlmap

    # @param [Hash<String, Object>] controlmap
    # @param [Hash<Symbol, Object>] options
    def initialize(controlmap, options = {})
      @controlmap = controlmap
      super options
    end

    # @!group margin settings
    # @return [Integer]
    def compute_w
      @text.w + 16
    end

    # @return [Integer]
    def compute_h
      @text.h + 32 # tailing
    end
    # @!endgroup margin settings

    protected def initialize_elements
      super
      @background = Renderers::Windowskin.new(
        texture: Game.instance.textures['ui/windowskin_help_panel'],
        affects_parent_size: false
      )

      @text = Moon::Label.new '', Game.instance.fonts['system.16']
      @text.string = '' <<
        "#{human_key(@controlmap["erase_tile"])} to erase current tile\n" <<
        "#{human_key(@controlmap["sample_tile"])} to sample current tile\n" <<
        "#{human_key(@controlmap["place_tile"])} to place tile\n" <<
        "#{human_key(@controlmap["toggle_tile_panel"])} opens Tile Panel\n" <<
        "#{human_key(@controlmap["edit_layer_0"])} selects the base layer for editing\n" <<
        "#{human_key(@controlmap["edit_layer_1"])} selects the detail layer for editing\n" <<
        "#{human_key(@controlmap["deactivate_layer_edit"])} deactivates layer editing\n" <<
        "#{human_key(@controlmap["zoom_in"])} increase Zoom Level\n" <<
        "#{human_key(@controlmap["zoom_out"])} descrease Zoom Level\n" <<
        "#{human_key(@controlmap["zoom_reset"])} reset Zoom Level\n" <<
        ''
      @text.position.set(8, 8, 0)

      add @background
      add @text
    end

    protected def initialize_events
      super
      on(:resize) { |e| @background.resize(e.parent.w, e.parent.h) }
    end

    private def human_key(*keys)
      keys.flatten.map { |key| Moon::Input.key_to_human_readable(key).first }.join(' or ').dump
    end
  end
end
