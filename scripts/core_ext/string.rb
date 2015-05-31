class String
  # @param [String] char
  # @return [Integer] number of characters present
  def count(char)
    bytes.count char.bytes[0]
  end unless method_defined? :count
end
