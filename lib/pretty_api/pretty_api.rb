# Permite permite homolocar los atributos de un JSON con los nested_attributes de Rails
# Renombrar los nombres de los arreglos de un JSON de 'nombre' a 'nombre_attributes'

module PrettyApi
  class << self
    def with_nested_attributes(params, attrs)
      case attrs
      when Hash
        with_nested_hash_attributes(params, attrs)
      when Array
        with_nested_array_attributes(params, attrs)
      when String, Symbol
        params["#{attrs}_attributes"] = params.delete attrs
      end
      params
    end

    private

    def with_nested_hash_attributes(params, attrs)
      attrs.each do |k, v|
        with_nested_attributes params[k], v
        with_nested_attributes params, k
      end
    end

    def with_nested_array_attributes(params, attrs)
      params.each do |np|
        attrs.each do |v|
          with_nested_attributes np, v
        end
      end
    end
  end
end