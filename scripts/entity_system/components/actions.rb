require 'scripts/entity_system/component'

module Models
  class Action < Moon::DataModel::Metal
  end
end

module Components
  class Actions < Base
    register :actions

    array :list, type: Models::Action
  end
end
