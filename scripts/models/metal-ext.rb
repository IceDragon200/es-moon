require 'scripts/database/queryable'

module Moon
  module DataModel
    class Metal
      include Database::Queryable

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
          (meta & value) == value
        # NOTE* Key Symbols will be converted to Strings
        # EG:
        # meta: { x: 'hi' }
        when 'meta'
          value.all? { |k, v| @meta[k.to_s] == v }
        else
          super key, value
        end
      end

      # @return [String]
      def self.basepath
        'data/'
      end

      # @param [String] rootname
      def save_file(rootname = nil)
        warn "no uri set, skipping saving of #{name}" unless self['uri'].present?

        path = File.join(self.class.basepath, self['uri'])
        path = File.join(rootname, path) if rootname
        path = path.split('/')
        basename = path.pop
        pathname = File.join(path.join('/'), "#{basename}.yml")

        FileUtils.mkdir_p(File.dirname(pathname))
        YAML.save_file(pathname, export)
      end
    end
  end
end
