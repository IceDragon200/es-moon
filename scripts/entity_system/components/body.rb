require 'scripts/entity_system/component'

module Components
  class Body < Base
    register :body

    field :speed, type: Float, default: 1.0
  end
end
