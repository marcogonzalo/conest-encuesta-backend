after "development:instrumentos" do
	instrumento = Instrumento.find_by(nombre: 'Evaluación Docente (rev.2014)')
	b1 = Bloque.find_or_create_by(nombre: 'Teoría', descripcion: 'Preguntas sobre aspectos teóricos de la asignatura', tipo: 'T')
	instrumento.bloques << b1
	b2 = Bloque.find_or_create_by(nombre: 'Práctica', descripcion: 'Preguntas sobre aspectos prácticos de la asignatura', tipo: 'P')
	instrumento.bloques << b2
	b3 = Bloque.find_or_create_by(nombre: 'Laboratorio', descripcion: 'Preguntas sobre el laboratorio de la asignatura', tipo: 'L')
	instrumento.bloques << b3
	b4 = Bloque.find_or_create_by(nombre: 'Docente', descripcion: 'Preguntas sobre el desempeño del docente de la asignatura', tipo: 'D')
	instrumento.bloques << b4
	b5 = Bloque.find_or_create_by(nombre: 'General', descripcion: 'Preguntas sobre la activiidad de la asignatura en general', tipo: 'G')
	instrumento.bloques << b5
end