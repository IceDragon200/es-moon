module ES
  module DataModel
    class EditorChunk < ::DataModel::Base
      field :position, type: Vector3,    allow_nil: true, default: nil
      field :data,     type: DataMatrix, allow_nil: true, default: nil
      field :flags,    type: DataMatrix, allow_nil: true, default: nil
      field :passages, type: Table,      allow_nil: true, default: nil
      field :tileset,  type: Tileset,    allow_nil: true, default: nil

      def bounds
        Rect.new(position.x, position.y, data.xsize, data.ysize)
      end
    end
  end
end
