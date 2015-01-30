json.array!(@materias) do |materia|
  json.extract! materia, :id, :codigo, :carrera_id, :plan_nombre, :nombre, :tipo_materia_id, :grupo_nota_id
  json.url api_v1_materia_url(materia, format: :json)
end
