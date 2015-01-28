json.array!(@docentes) do |docente|
  json.extract! docente, :id, :cedula, :primer_nombre, :segundo_nombre, :primer_apellido, :segundo_apellido
  json.url docente_url(docente, format: :json)
end
