require 'scripts/models/map_editor_model'
require 'scripts/bindings/map_editor_model_binder'
require 'scripts/controllers/map_editor_gui_controller'
require 'scripts/controllers/map_editor_map_controller'
require 'scripts/input_delegates/map_editor_input_delegate'
require 'scripts/views/map_editor_gui_view'
require 'scripts/views/map_editor_map_view'

module States
  # Built-in Map Editor for editing ES-Moon style maps and chunks
  class MapEditor < States::Base
    attr_reader :model
    attr_reader :controller
    attr_reader :view

    def init
      super
      @tp_clock = Moon::Clock.new

      create_mvc
      create_input_delegate
      create_world
      create_map
      create_autosave_interval
    end

    def start
      super
      #@map_controller.refresh_follow
      @gui_controller.refresh_follow
      @map_controller.start
      @gui_controller.start

      @model.notify_all

      # debug
      scheduler.print_jobs
    end

    private def create_model
      view = engine.screen.rect
      view = view.translate(-(view.w / 2), -(view.h / 2))
      data = File.exist?('editor.yml') ? YAML.load_file('editor.yml') : {}
      @model = MapEditorModelBinder.new(model: Models::MapEditorModel.new(data))
      @model.camera = Camera2.new(view: view)
      @model.tile_palette.tileset = game.database['tilesets/common']
      @model.layer ||= -1
    end

    private def create_view
      @map_view = MapEditorMapView.new(game: game, model: @model, view: engine.screen.rect)
      @gui_view = MapEditorGuiView.new(game: game, model: @model, view: engine.screen.rect.contract(16))
      @gui_view.tileset = @model.tile_palette.tileset
      @gui_view.spritesheet = game.spritesheets[@gui_view.tileset.spritesheet_id]
      @renderer.add @map_view
      @gui.add @gui_view
    end

    private def create_controller
      @map_controller = MapEditorMapController.new engine, @model, @map_view
      @gui_controller = MapEditorGuiController.new engine, @model, @gui_view
      @gui_controller.map_controller = @map_controller
      @map_controller.gui_controller = @gui_controller
      @update_list.push @map_controller
      @update_list.push @gui_controller
    end

    private def create_mvc
      create_model
      create_view
      create_controller
    end

    private def create_input_delegate
      @router = MapEditorInputDelegate.new engine, @gui_controller

      @input_list << @router
      @input_list << @gui_view
      @input_list << @map_view

      input.on :mousemove do |e|
        @gui_controller.set_cursor_position_from_mouse(e.position)
      end
    end

    private def create_world
      @world = Moon::EntitySystem::World.new
      @update_list.unshift @world
    end

    private def create_map
      @model.map = game.database[game.database['system']['starting_map']]
    end

    private def create_autosave_interval
      @autosave_interval = scheduler.every('3m') do
        @gui_controller.autosave
      end.tag('autosave')
    end

    private def update_world(delta)
      @world.update(delta)
    end

    def update(delta)
      update_world(delta)
      super delta
    end
  end
end
