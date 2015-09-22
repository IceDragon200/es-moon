require 'scripts/ui/text_list'
require 'scripts/states/map_editor'
require 'scripts/states/map_viewer'
require 'scripts/states/new_game'
require 'scripts/states/editors/tileset_editor'

module States
  class Title < Base
    def init
      super
      create_background
      create_title_menu
    end

    def start
      super
      t = TweenScheduler.new(scheduler)
      t.tween_obj @background.sprite, :opacity, to: 1.0, duration: '2s', easer: Moon::Easing::Linear
      scheduler.print_jobs
    end

    def create_background
      tex = game.texture_cache['backgrounds/title']
      @background = Moon::Sprite.new(tex).to_sprite_context
      @background.sprite.opacity = 0.0

      @gui.add @background
    end

    def create_title_menu
      @title_menu = UI::TextList.new font: game.font_cache['system']
      @title_menu.add_entry(:newgame,        name: 'New Game',       cb: -> { state_manager.change States::NewGame })
      @title_menu.add_entry(:continue,       name: 'Continue',       enabled: false)
      @title_menu.add_entry(:map_viewer,     name: 'Map Viewer',     cb: -> { state_manager.change States::MapViewer })
      @title_menu.add_entry(:map_editor,     name: 'Map Editor',     cb: -> { state_manager.change States::MapEditor })
      @title_menu.add_entry(:tileset_editor, name: 'Tileset Editor', cb: -> { state_manager.change States::TilesetEditor })
      @title_menu.add_entry(:quit,           name: 'Quit',           cb: -> { state_manager.pop })
      @title_menu.tag('#menu')
      @title_menu.align!('center', screen.rect)
      #@title_menu.position = Moon::Vector3.new(8, 4, 0)

      @title_menu.elements.each_with_index do |elm, i|
        elm.enable_default_events
        elm.on :click do |e|
          @title_menu.index = i
        end

        elm.on :double_click do
          @title_menu.index = i
          on_title_menu_accept
        end
      end

      @gui.add @title_menu
    end
  end
end
