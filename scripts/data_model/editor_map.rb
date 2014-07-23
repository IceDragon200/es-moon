module ES
  module DataModel
    class EditorMap < ::DataModel::Base
      field :chunks, type: [EditorChunk], default: proc{[]}

      def bounds
        l, r, t, b = nil, nil, nil, nil
        chunks.each do |chunk|
          l ||= chunk.position
          r ||= chunk.position
          t ||= chunk.position
          b ||= chunk.position
          if l.x > chunk.position.x
            l = chunk.position
          end
          if r.x < chunk.bounds.x2
            r = Vector3.new(chunk.bounds.x2, 0)
          end
          if t.y > chunk.position.y
            t = chunk.position
          end
          if b.y < chunk.bounds.y2
            b = Vector3.new(0, chunk.bounds.y2)
          end
        end
        Rect.new(l.x, t.y, r.x - l.x, b.y - t.y)
      end

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
