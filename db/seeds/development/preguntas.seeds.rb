after "development:bloques" do
	instrumento = Instrumento.find_by(nombre: 'Evaluación Docente (rev.2014)')
	if instrumento
		tp = TipoPregunta.find_by(valor: 'numero')

		bloque_t = instrumento.bloques.find_by(tipo: 'T')
		if bloque_t
			p1 = Pregunta.find_or_create_by(interrogante: 'La densidad de contenidos es asimilable en un trimestre', tipo_pregunta_id: tp.id)
			bloque_t.preguntas << p1
		end

		bloque_p = instrumento.bloques.find_by(tipo: 'P')
		if bloque_p
		end

		bloque_l = instrumento.bloques.find_by(tipo: 'L')
		if bloque_l
			p2 = Pregunta.find_or_create_by(interrogante: 'Dotación de la universidad de materiales y equipos requeridos', tipo_pregunta_id: tp.id)
			bloque_l.preguntas << p2
		end

		bloque_d = instrumento.bloques.find_by(tipo: 'D')
		if bloque_d
			p3 = Pregunta.find_or_create_by(interrogante: '¿Expuso claramente el programa al inicio del curso?', tipo_pregunta_id: tp.id)
			bloque_d.preguntas << p3
			p4 = Pregunta.find_or_create_by(interrogante: '¿Informó con precisión sobre el proceso de evaluación?', tipo_pregunta_id: tp.id)
			bloque_d.preguntas << p4
			p5 = Pregunta.find_or_create_by(interrogante: 'Le dedicó el tiempo apropiado a cada tema del programa', tipo_pregunta_id: tp.id)
			bloque_d.preguntas << p5
			p6 = Pregunta.find_or_create_by(interrogante: 'Desarrolló ordenadamente las actividades docentes', tipo_pregunta_id: tp.id)
			bloque_d.preguntas << p6
			p7 = Pregunta.find_or_create_by(interrogante: 'Logró comunicarse efectivamente con el estudiante', tipo_pregunta_id: tp.id)
			bloque_d.preguntas << p7
			p8 = Pregunta.find_or_create_by(interrogante: 'Orientó sobre el uso de material necesario para el aprendizaje', tipo_pregunta_id: tp.id)
			bloque_d.preguntas << p8
			p9 = Pregunta.find_or_create_by(interrogante: 'Indicó claramente la relación entre los temas del curso', tipo_pregunta_id: tp.id)
			bloque_d.preguntas << p9
			p10 = Pregunta.find_or_create_by(interrogante: 'Adaptó sus explicaciones para hacerse entender mejor', tipo_pregunta_id: tp.id)
			bloque_d.preguntas << p10
			p11 = Pregunta.find_or_create_by(interrogante: 'Explicó claramente la relación entre la teoría y la práctica', tipo_pregunta_id: tp.id)
			bloque_d.preguntas << p11
			p12 = Pregunta.find_or_create_by(interrogante: 'Fue receptivo a las intervenciones de los estudiantes', tipo_pregunta_id: tp.id)
			bloque_d.preguntas << p12
			p13 = Pregunta.find_or_create_by(interrogante: 'Fomentó un ambiente propicio para el aprendizaje', tipo_pregunta_id: tp.id)
			bloque_d.preguntas << p13
			p14 = Pregunta.find_or_create_by(interrogante: 'Mantuvo criterios claros de evaluación', tipo_pregunta_id: tp.id)
			bloque_d.preguntas << p14
			p15 = Pregunta.find_or_create_by(interrogante: 'Muestra disposición para atender individualmente a los estudiantes', tipo_pregunta_id: tp.id)
			bloque_d.preguntas << p15
			p16 = Pregunta.find_or_create_by(interrogante: 'Mantuvo una actitud respetuosa hacia los estudiantes', tipo_pregunta_id: tp.id)
			bloque_d.preguntas << p16
			p17 = Pregunta.find_or_create_by(interrogante: 'El profesor cumplió con el horario de clases', tipo_pregunta_id: tp.id)
			bloque_d.preguntas << p17
			p18 = Pregunta.find_or_create_by(interrogante: 'Planificó tiempo suficiente para las evaluaciones', tipo_pregunta_id: tp.id)
			bloque_d.preguntas << p18
			p19 = Pregunta.find_or_create_by(interrogante: 'Las evaluaciones se correspondieron con lo desarrollado durante el curso', tipo_pregunta_id: tp.id)
			bloque_d.preguntas << p19
			p20 = Pregunta.find_or_create_by(interrogante: 'Realizó la entrega y revisión oportuna de los resultados de las evaluaciones', tipo_pregunta_id: tp.id)
			bloque_d.preguntas << p20
			p21 = Pregunta.find_or_create_by(interrogante: 'Motivó la búsqueda activa de conocimiento', tipo_pregunta_id: tp.id)
			bloque_d.preguntas << p21
			p22 = Pregunta.find_or_create_by(interrogante: 'Estimuló la participación del estudiante en el proceso de aprendizaje', tipo_pregunta_id: tp.id)
			bloque_d.preguntas << p22
			p23 = Pregunta.find_or_create_by(interrogante: 'Evalúe el desempeño global del profesor', tipo_pregunta_id: tp.id)
			bloque_d.preguntas << p23
			p24 = Pregunta.find_or_create_by(interrogante: '¿Avalaría que su profesor fuera postulado a la destacada labor docente?', tipo_pregunta_id: tp.id)
			bloque_d.preguntas << p24
		end

		bloque_g = instrumento.bloques.find_by(tipo: 'G')
		if bloque_g
			p25 = Pregunta.find_or_create_by(interrogante: 'Preparación previa para cursar esta asignatura', tipo_pregunta_id: tp.id)
			bloque_g.preguntas << p25
			p26 = Pregunta.find_or_create_by(interrogante: 'Dedicación de tiempo y esfuerzo a este curso', tipo_pregunta_id: tp.id)
			bloque_g.preguntas << p26
			p27 = Pregunta.find_or_create_by(interrogante: 'Contribución del curso a su formación como profesional', tipo_pregunta_id: tp.id)
			bloque_g.preguntas << p27
			p28 = Pregunta.find_or_create_by(interrogante: 'Las actividades están bien planificadas para obtener resultados', tipo_pregunta_id: tp.id)
			bloque_g.preguntas << p28
			p29 = Pregunta.find_or_create_by(interrogante: 'El esfuerzo requerido se corresponde con el número de créditos', tipo_pregunta_id: tp.id)
			bloque_g.preguntas << p29
			p30 = Pregunta.find_or_create_by(interrogante: 'Disponibilidad personal de libros, guías y material docente requeridos', tipo_pregunta_id: tp.id)
			bloque_g.preguntas << p30
			p31 = Pregunta.find_or_create_by(interrogante: 'Aprendizaje efectivo que usted considera haber logrado en el curso', tipo_pregunta_id: tp.id)
			bloque_g.preguntas << p31
			p32 = Pregunta.find_or_create_by(interrogante: 'Grado de dificultad del curso', tipo_pregunta_id: tp.id)
			bloque_g.preguntas << p32
			p33 = Pregunta.find_or_create_by(interrogante: 'Expectativa de calificación final', tipo_pregunta_id: tp.id)
			bloque_g.preguntas << p33
		end
	end
end