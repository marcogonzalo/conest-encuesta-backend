json.extract! @instrumento, :id, :nombre, :descripcion, :created_at, :updated_at
json.bloques @instrumento.bloques, :id, :nombre, :descripcion, :tipo
