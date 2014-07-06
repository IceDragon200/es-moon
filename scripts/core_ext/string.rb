class String

  def count(char)
    bytes.count char.bytes[0]
  end unless method_defined? :count

end