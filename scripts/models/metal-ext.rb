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
        path = File.join(self.class.basepath, id)
        path = File.join(rootname, path) if rootname
        pathname = path + '.yml'

        FileUtils.mkdir_p(File.dirname(pathname))
        YAML.save_file(pathname, export)
        self
      end
    end
  end
end
