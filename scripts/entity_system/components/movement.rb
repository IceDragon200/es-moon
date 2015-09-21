require 'scripts/entity_system/component'

module Components
  class Movement < Base
    register :movement

    field :vect, type: Moon::Vector2, default: ->(t, _) { t.model.new }
  end
end
