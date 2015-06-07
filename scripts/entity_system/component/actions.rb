module ES
  class Action < Moon::DataModel::Metal
  end
end

class ActionsComponent
  include Moon::EntitySystem::Component
  register :actions

  array :list, type: ES::Action
end
