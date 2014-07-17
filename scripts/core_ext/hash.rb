class Hash
  def exclude(*excluded_keys)
    result = dup
    excluded_keys.each { |key| result.delete(key) }
    result
  end

  def permit(*keys)
    keys.each_with_object({}) { |key, hash| hash[key] = self[key] }
  end
end
