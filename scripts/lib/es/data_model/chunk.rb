module ES
  module DataModel
    class Chunk < BaseModel

      field :data,     type: DataMatrix, allow_nil: true, default: nil
      field :flags,    type: DataMatrix, allow_nil: true, default: nil
      field :passages, type: Table,      allow_nil: true, default: nil

      def save_file
        path = ("data/chunks/" + name).split("/")
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