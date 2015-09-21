require 'scripts/models/metal-ext'

module Moon
  module DataModel
    class Base
      include Moon::Taggable

      field :uri, type: String, default: ''

      # When querying the model about its properties this is used.
      #
      # @param [String|Symbol] key
      # @param [Object] value
      # @return [Boolean]
      def query(key, value)
        # tags and meta are special cases
        case key.to_s
        # EG:
        # tags: ["red", "herb", "thing"]
        # tag: "herb"
        when 'tags', 'tag'
          value = [value] unless value.is_a?(Array)
          (tags & value) == value
        # NOTE* Key Symbols will be converted to Strings
        # EG:
        # meta: { x: 'hi' }
        when 'meta'
          value.all? { |k, v| @meta[k.to_s] == v }
        else
          super key, value
        end
      end
    end
  end
end
