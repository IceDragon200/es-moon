module ES
  module DataModel
    class EditorMap < ::DataModel::Base
      field :chunks, type: [EditorChunk], allow_nil: true, default: nil

      def to_map
        map = Map.new
        map.set(self.to_h.exclude(:chunks))
        map.chunks = chunks.map do |chunk|
          chunk.to_chunk_head
        end
        map
      end
    end
  end
end
