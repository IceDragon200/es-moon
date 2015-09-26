require 'scripts/models/map'
require 'scripts/entity_system/component'

module Components
  class Level < Base
    register :level

    field :map, type: Models::Map, default: nil
  end
end
