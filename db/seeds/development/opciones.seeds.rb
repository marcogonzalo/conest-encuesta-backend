after "development:preguntas" do
	Pregunta.all.each do |p|
		Opcion.find_or_create_by(pregunta: p, etiqueta: 1, valor: 1)
		Opcion.find_or_create_by(pregunta: p, etiqueta: 2, valor: 2)
		Opcion.find_or_create_by(pregunta: p, etiqueta: 3, valor: 3)
		Opcion.find_or_create_by(pregunta: p, etiqueta: 4, valor: 4)
		Opcion.find_or_create_by(pregunta: p, etiqueta: 5, valor: 5)
	end
end