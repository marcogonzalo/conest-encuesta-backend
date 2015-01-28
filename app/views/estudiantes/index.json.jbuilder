json.array!(@estudiantes) do |estudiante|
  json.extract! estudiante, :id, :cedula, :primer_nombre, :segundo_nombre, :primer_apellido, :segundo_apellido
  json.url estudiante_url(estudiante, format: :json)
end
