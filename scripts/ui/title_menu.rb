module UI
  class TitleMenu < TextList
    def post_initialize
      super
      add_entry(:newgame,    name: 'New Game')
      add_entry(:continue,   name: 'Continue', enabled: false)
      add_entry(:map_viewer, name: 'Map Viewer')
      add_entry(:map_editor, name: 'Map Editor')
      add_entry(:quit,       name: 'Quit')
    end
  end
end
