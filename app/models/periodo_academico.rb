class PeriodoAcademico < ActiveRecord::Base
	has_many :ofertas_periodo

	validates :periodo,
				presence: true,
				uniqueness: true

	validates :asignaturas_hash_sum,
				presence: true,
				uniqueness: true

	validates :estudiantes_hash_sum,
				allow_nil: true,
				allow_blank: true,
				uniqueness: true


    # Método que procesa la información recibida desde CONEST sobre el período académico registrado
    # En 'd' se contienen los datos de la respuesta enviada por CONEST
    def self.procesar_periodo(periodo_academico, datos_conest, instrumento_id = nil)
      # Iterar sobre las organizaciones (Escuelas)
      datos_conest['organizaciones'].each do |o|
        # Para cada Carrera de cada Organizacion
        o['carreras'].each do |c|
          @carrera = Carrera.find_or_initialize_by(codigo: c['id'], organizacion_id: o['id'])
          if @carrera.id.nil?
            @carrera.update(nombre: c['nombre'])
          end

          # Para cada Materia de cada Carrera
          c['materias'].each do |m|
            @materia = Materia.find_or_initialize_by(carrera: @carrera, plan_nombre: c['plan_nombre'], codigo: m['codigo'])
            if @materia.id.nil?
              @materia.update(nombre: m['nombre'], tipo_materia_id: m['tipo_materia_id'], grupo_nota_id: m['grupo_nota_id'])
            end
            
            # Obtengo el Coordinador
            @coordinador = Docente.find_or_initialize_by(cedula: m['coordinador']['cedula'])
            @coordinador.update(m['coordinador'])
            
            # Creación de usuario de Coordinador
            unless Usuario.exists?(cedula: @coordinador.cedula)
              rol = Rol.find_by(nombre: 'Docente')
              usuario = Usuario.create(cedula: @coordinador.cedula, clave: @coordinador.cedula, rol: rol)
            end


            # Obtengo la oferta en el periodo
            @oferta_periodo = OfertaPeriodo.find_or_initialize_by(periodo_academico: periodo_academico, materia: @materia)
            @oferta_periodo.update(docente_coordinador: @coordinador)
            
            # Para cada Seccion de cada Materia
            m['secciones'].each do |s|

              # Obtengo el docente
              @docente = Docente.find_or_initialize_by(cedula: s['docente']['cedula'])
              @docente.update(s['docente'])

              # Creación de usuarios de Docente
              unless Usuario.exists?(cedula: @docente.cedula)
                rol = Rol.find_by(nombre: 'Docente')
                usuario = Usuario.create(cedula: @docente.cedula, clave: @docente.cedula, rol: rol)
              end
              
              # Registro la oferta academica para ese periodo
              @oferta_academica = OfertaAcademica.find_or_initialize_by(nombre_seccion: s['nombre'], oferta_periodo: @oferta_periodo)
              @oferta_academica.update(docente: @docente, promedio_general: s['promedio_general'], nro_estudiantes: s['nro_estudiantes'], nro_estudiantes_retirados: s['nro_estudiantes_retirados'], nro_estudiantes_aprobados: s['nro_estudiantes_aprobados'], nro_estudiantes_equivalencia: s['nro_estudiantes_equivalencia'], nro_estudiantes_suficiencia: s['nro_estudiantes_suficiencia'], nro_estudiantes_reparacion: s['nro_estudiantes_repararon'], nro_estudiantes_aplazados: s['nro_estudiantes_aplazados'], tipo_estatus_calificacion_id: s['tipo_status_calificacion_id'])

              @consulta = Consulta.find_or_initialize_by(oferta_academica: @oferta_academica)

              instrumento = instrumento_id.nil? ? Instrumento.all.last : Instrumento.find(instrumento_id)

              @consulta.update(instrumento: instrumento)
            end
          end
        end
      end
    end

	def sincronizar_periodo(respuesta_conest, datos_conest, instrumento_id)
		if self.id.nil?
		# Crear el nuevo periodo academico
			self.update(asignaturas_hash_sum: respuesta_conest['sha1_sum'], sincronizacion: respuesta_conest['fecha_hora'])
			PeriodoAcademico.procesar_periodo(self, datos_conest, instrumento_id)
			return :created
		else
			# Si el hash es el mismo no hay cambios en el listado
			if self.asignaturas_hash_sum.eql?(respuesta_conest['sha1_sum'])
				return :not_modified
			else
			# Si no es el mismo, actualizo y continuo
				self.update(asignaturas_hash_sum: respuesta_conest['sha1_sum'], sincronizacion: respuesta_conest['fecha_hora'])
				PeriodoAcademico.procesar_periodo(self, datos_conest, instrumento_id)
				return :ok
			end
		end
    end

    def sincronizar_estudiantes(respuesta_conest)
    	# Si el hash es el mismo no hay cambios en el listado
		if self.estudiantes_hash_sum.eql?(respuesta_conest['sha1_sum'])
			return :not_modified
		else
            # Datos de la respuesta enviada por Conest
            datos_conest = respuesta_conest['datos']
			
			self.update(estudiantes_hash_sum: respuesta_conest['sha1_sum'], sincronizacion: respuesta_conest['fecha_hora'])
			datos_conest['carreras'].each do |c|
			  carrera = Carrera.find_by(codigo: c['id'])
			  c['estudiantes'].each do |e|
			    # Obtengo el Estudiante
			    estudiante = Estudiante.find_or_initialize_by(cedula: e['cedula'])
			    estudiante.update(cedula: e['cedula'], primer_nombre: e['primer_nombre'], segundo_nombre: e['segundo_nombre'], primer_apellido: e['primer_apellido'], segundo_apellido: e['segundo_apellido'])

			    # Creación de usuarios de Estudiante
			    unless Usuario.exists?(cedula: estudiante.cedula)
			      rol = Rol.find_by(nombre: 'Estudiante')
			      usuario = Usuario.create(cedula: estudiante.cedula, clave: estudiante.cedula, rol: rol)
			    end
			    
			    e['materias'].each do |m|
			      materia = Materia.find_by(codigo: m['codigo'], carrera: carrera)
			      oferta_periodo = materia.ofertas_periodo.find_by(periodo_academico: self)
			      oferta_academica = oferta_periodo.oferta_academica.find_by(oferta_periodo: oferta_periodo, nombre_seccion: m['nombre_seccion'])

			      control_consulta = ControlConsulta.find_or_create_by(oferta_academica: oferta_academica, estudiante: estudiante)
			    end
			  end
			end
			return :ok
		end
    end
end
