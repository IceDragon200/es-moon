require 'scripts/entity_system/component'

module Components
  class WaitTime < Base
    register :wait_time

    field :value, type: Integer, default: 0
    field :max,   type: Integer, default: 0
    field :reset, type: Integer, default: 0
  end
end
