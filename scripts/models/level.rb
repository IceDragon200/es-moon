require 'scripts/models/base'
require 'scripts/models/map'

module Models
  class Level < Base
    field :map_id, type: String, default: ''

    attr_accessor :map
  end
end
