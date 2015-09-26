require 'scripts/entity_system/component'

module Components
  # Components responsible for entity transfer, usually added and removed as
  # needed, this allows entities to be transfered across maps.
  class Transfer < Base
    register :transfer

    field :pending, type: Boolean, default: false
    field :map_id, type: String, default: ''
    field :x, type: Integer, default: 0
    field :y, type: Integer, default: 0
  end
end
