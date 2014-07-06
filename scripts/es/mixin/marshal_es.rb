module MarshalES

  def export_es
    ivtable = instance_variables.each_with_object({}) do |iv, hash|
      value = instance_variable_get iv
      hash[iv] = value.respond_to?(:export_es) ? value.export_es : value
    end
    {
      "&class" => self.class,
      "&ivtable" => ivtable
    }
  end

  def import_es(data)
    safe_data = data.dup
    safe_data.delete("&class")
    safe_data["&ivtable"].each do |key, value|
      instance_variable_set key, value
    end
  end

end