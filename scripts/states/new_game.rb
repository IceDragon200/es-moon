module States
  # Used for preparing a new game
  class NewGame < Base
    def invoke
      game.map = ES::Map.find_by(uri: '/maps/school/f1')
      state_manager.change States::Map
    end
  end
end
