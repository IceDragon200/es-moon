require 'scripts/ui/text_list'

module UI
  class BattleActionList < TextList
    def post_initialize
      super
      add_entry(:attack, name: 'Attack')
      add_entry(:move,   name: 'Move')
    end
  end
end
