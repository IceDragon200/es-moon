require 'yaml'

def repair_data(data)
  case data
  when Array
    data.map { |d| repair_data d }
  when Hash
    if (klass = data['&class']) && klass == 'Moon::Rect'
      data['w'] = data.delete('width') if data.key?('width')
      data['h'] = data.delete('height') if data.key?('height')
      data
    else
      data.map do |key, value|
        [repair_data(key), repair_data(value)]
      end.to_h
    end
  else
    data
  end
end

Dir.glob('**/*.yml') do |filename|
  File.write(filename, repair_data(YAML.load_file(filename)).to_yaml)
end
