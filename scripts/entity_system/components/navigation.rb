require 'scripts/entity_system/component'

module Components
  class Navigation < Base
    register :navigation

    field :destination, type: Moon::Vector3
  end
end
