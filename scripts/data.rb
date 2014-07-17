## maps
ES::Database.load_data_file :map, "maps/school/f1"


ES::Database.where(:map).each do |map|
  map.chunks.each do |refhead|
    ES::Database.load_data_file :chunk, refhead["uri"]
  end
end
