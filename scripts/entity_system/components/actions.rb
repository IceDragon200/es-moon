require 'scripts/entity_system/component'

module ES
  class Action < Moon::DataModel::Metal
  end
end

module Components
  class Actions < Base
    register :actions

    array :list, type: ES::Action
  end
end
