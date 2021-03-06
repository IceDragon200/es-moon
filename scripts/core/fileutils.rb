module FileUtils
  # @param [String] path
  def self.mkdir_p(path)
    dirs = path.gsub(/\/+/, '/').split('/')
    dirs.size.times do |i|
      pth = dirs[0, i + 1].join('/')
      Dir.mkdir(pth) unless Dir.exist?(pth)
    end
  end
end
