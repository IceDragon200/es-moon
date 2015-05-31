# A limited access Hash, which only allows reading and #fetch-ing
class FetchOnlyHash
  include Enumerable

  # @param [#fetch, #each, #each_pair] data
  def initialize(data)
    @data = data
  end

  # Fetches value at key, fails if key is not found.
  #
  # @param [Object] key
  # @return [Object]
  def [](key)
    @data.fetch(key)
  end

  # Yields each element in the data object
  def each(&block)
    @data.each(&block)
  end

  # Yields each element pair in the data object
  def each_pair(&block)
    @data.each_pair(&block)
  end
end
