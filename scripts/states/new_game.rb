module States
  # Used for preparing a new game
  class NewGame < Base
    def invoke
      state_manager.change States::Map
    end
  end
end
