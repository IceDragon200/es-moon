module ES
  module DataModel
    class Map < BaseModel

      ##
      # Array<Hash> chunks lookup table
      field :chunks,         type: [Hash],    default: proc {[]}
      field :chunk_position, type: [Vector3], default: proc {[]}

      def save_file
        path = ("data/maps/" + name).split("/")
        filename = path.pop
        pathname = "#{path.join("/")}/#{filename}.yml"
        path.size.times do |i|
          pth = path[0, i+1].join("/")
          Dir.mkdir pth unless Dir.exist? pth
        end
        File.open pathname, "w" do |file|
          file.write YAML.dump(export)
        end
      end

    end
  end
end