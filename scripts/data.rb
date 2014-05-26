## maps
ES::Database.load_data_file :map,   "school_f1"


ES::Database.where(:map).each do |map|
  map.chunks.each do |data|
    ES::Database.load_data_file :chunk, data.stringify_keys["name"]
  end
end