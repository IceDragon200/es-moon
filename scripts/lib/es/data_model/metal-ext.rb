module Moon
  module DataModel
    class Metal

      include Queryable

      ###
      # When questionin the model about its properties this is used.
      # @param [String|Symbol] key
      # @param [Object] value
      # @return [Boolean]
      ###
      def query(key, value)
        # tags and meta are special cases
        case key.to_s
        ###
        # EG:
        # tags: ["red", "herb", "thing"]
        # tag: "herb"
        ###
        when "tags", "tag"
          value = [value] unless value.is_a?(Array)
          (meta & value) == value
        ###
        # NOTE* Key Symbols will be converted to Strings
        # EG:
        # meta: { x: "hi" }
        ###
        when "meta"
          value.all? { |k, v| @meta[k.to_s] == v }
        else
          super key, value
        end
      end

      ###
      # @return [String]
      ###
      def self.basepath
        "data/"
      end

      ###
      #
      ###
      def save_file
        path = (self.class.basepath + name).split("/")
        basename = path.pop
        pathname = "#{path.join("/")}/#{basename}.yml"

        Dir.mkdir_p path.join("/")
        YAML.save_file(pathname, export)
      end

    end
  end
end
