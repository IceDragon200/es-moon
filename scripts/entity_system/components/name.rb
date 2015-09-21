require 'scripts/entity_system/component'

module Components
  class Name < Base
    register :name

    field :string, field: String, default: 'Anonymous'
  end
end
