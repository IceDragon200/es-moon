class Table

  def set_from_strmap(str, strmap)
    str.bytes.each_with_index { |c, i| set_by_index(i, strmap[c.chr]) }
  end

end