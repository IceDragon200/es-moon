## maps
assets = {}
vfs = YAML.load_file('data/vfs.yml')['data']

character_assets = assets[:character] = {}
vfs['characters'].each do |key, file|
  character_assets[key] = ES::Character.load_file file.gsub('.yml', '')
end

chunk_assets = assets[:chunk] = {}
vfs['chunks'].each do |key, file|
  chunk_assets[key] = ES::Chunk.load_file file.gsub('.yml', '')
end

map_assets = assets[:map] = {}
vfs['maps'].each do |key, file|
  map_assets[key] = ES::Map.load_file file.gsub('.yml', '')
end

# recursive load
ES::Map.all.each do |map|
  map.chunks.each do |refhead|
    ES::Chunk.load_file refhead.uri
  end
end

ES::Chunk.all.each do |chunk|
  next if chunk.tileset.uri.blank?
  ES::Tileset.load_file chunk.tileset.uri
end
