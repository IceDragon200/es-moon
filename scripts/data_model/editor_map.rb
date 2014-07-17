module ES
  module DataModel
    class EditorMap < ::DataModel::Base
      field :chunks, type: [EditorChunk], allow_nil: true, default: nil
    end
  end
end
