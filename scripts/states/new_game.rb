module States
  # Used for preparing a new game
  class NewGame < Base
    def invoke
      game = Game.new
      cvar['game'] = game
      game.map = Dataman.load_editor_map(uri: '/maps/school/f1')
      state_manager.change States::Map
    end
  end
end
