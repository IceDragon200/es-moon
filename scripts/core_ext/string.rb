class String
  # Counts the number of occurences of the specified character
  #
  # @param [String] char - a single character
  # @return [Integer] number of characters present
  def count(char)
    bytes.count char.bytes[0]
  end unless method_defined? :count
end
