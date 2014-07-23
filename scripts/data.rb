## maps
Database.load_data_file :map, "maps/school/f1"

Database.where(:map).each do |map|
  map.chunks.each do |refhead|
    Database.load_data_file :chunk, refhead["uri"]
  end
end

Database.where(:chunk).each do |chunk|
  Database.load_data_file :tileset, chunk.tileset.uri
end
