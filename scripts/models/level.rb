require 'scripts/models/map'

module ES
  class Level < Moon::DataModel::Base
    field :map_id, type: String, default: ''
    attr_accessor :map
  end
end
