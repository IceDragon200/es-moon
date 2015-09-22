require 'scripts/database/queryable'

module Moon
  module DataModel
    class Metal
      include Database::Queryable

      # Basepath for {#save_file}
      # @return [String]
      def self.basepath
        'data/'
      end

      # Saves the current model to disk, an optional rootname may be
      # specified to move the root directory.
      #
      # @param [String] rootname
      # @return [self]
      def save_file(rootname = nil)
        warn "no id set, skipping saving of #{name}" unless self['id'].present?

        path = File.join(self.class.basepath, self['id'])
        path = File.join(rootname, path) if rootname
        path = path.split('/')
        basename = path.pop
        pathname = File.join(path.join('/'), "#{basename}.yml")

        FileUtils.mkdir_p(File.dirname(pathname))
        YAML.save_file(pathname, export)
        self
      end
    end
  end
end
