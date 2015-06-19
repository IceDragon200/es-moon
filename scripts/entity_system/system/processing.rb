require 'scripts/entity_system/system'

module ES
  module EntitySystem
    class System
      # Based on Artemis EntityProcessingSystem
      module Processing
        def filtered
        end

        def process(entity, delta)
        end

        def update_process(delta)
          filtered do |entity|
            process(entity, delta)
          end
        end

        def update(delta)
          update_process(delta)
        end
      end
    end
  end
end
