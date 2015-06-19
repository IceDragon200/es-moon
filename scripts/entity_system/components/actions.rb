require 'scripts/entity_system/component'

module ES
  class Action < Moon::DataModel::Metal
  end
end

class ActionsComponent < ES::EntitySystem::Component
  register :actions

  array :list, type: ES::Action
end
