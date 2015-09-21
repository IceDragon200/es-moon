require 'scripts/entity_system/component'

module Components
  class Health < Base
    register :health

    field :value, type: Integer, default: 0
    field :max,   type: Integer, default: 0

    # @return [Float]
    def rate
      value / max.to_f
    end

    # @param [Float] rate
    def rate=(rate)
      self.value = (rate * max).to_i
    end
  end
end
