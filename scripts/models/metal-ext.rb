require 'scripts/database/queryable'

module Moon
  module DataModel
    class Metal
      include Database::Queryable

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
