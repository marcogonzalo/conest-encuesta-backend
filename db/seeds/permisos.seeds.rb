after 'roles' do
	# Permiso de SuperAdmin
	Permiso.find_or_create_by(clase: 'all', accion: 'manage', nombre: 'accesoTotal', descripcion: 'Permiso Universal')

	# Permisos para gestion
	Permiso.find_or_create_by(clase: 'Instrumento', accion: 'index', nombre: 'listarInstrumentos')
	Permiso.find_or_create_by(clase: 'Instrumento', accion: 'show', nombre: 'verInstrumento')
	Permiso.find_or_create_by(clase: 'Instrumento', accion: 'create', nombre: 'crearInstrumento')
	Permiso.find_or_create_by(clase: 'Instrumento', accion: 'update', nombre: 'editarInstrumento')
	Permiso.find_or_create_by(clase: 'Instrumento', accion: 'destroy', nombre: 'eliminarInstrumento')

	Permiso.find_or_create_by(clase: 'Estudiante', accion: 'consultas_sin_responder', nombre:'listarConsultasSinResponder')
	Permiso.find_or_create_by(clase: 'Consulta', accion: 'responder', nombre:'responderConsultas')

	# Permisos para gestion de períodos
	Permiso.find_or_create_by(clase: 'PeriodoAcademico', accion: 'index', nombre: 'listarPeriodos')
	Permiso.find_or_create_by(clase: 'PeriodoAcademico', accion: 'create', nombre: 'crearPeriodo')
	Permiso.find_or_create_by(clase: 'PeriodoAcademico', accion: 'update', nombre: 'sincronizarPeriodo')
	Permiso.find_or_create_by(clase: 'PeriodoAcademico', accion: 'sincronizar_estudiantes', nombre: 'sincronizarEstudiantes')

	# Permisos para gestion de ofertas academicas en periodos
	Permiso.find_or_create_by(clase: 'OfertaPeriodo', accion: 'cambiar_instrumento', nombre: 'cambiarInstrumentoDeConsulta')

	# Permisos para consulta de reportes de materia
	Permiso.find_or_create_by(clase: 'Reporte', accion: 'index', nombre: 'listarReportes')
	Permiso.find_or_create_by(clase: 'ReporteHistorico', accion: 'reporte_historico_pregunta_de_materia', nombre: 'verReporteHistoricoDePreguntaEnMateria')
	Permiso.find_or_create_by(clase: 'ReporteHistorico', accion: 'reporte_historico_comparado_de_materia', nombre: 'verReporteHistoricoComparadoDeMateria')
	Permiso.find_or_create_by(clase: 'ReporteHistorico', accion: 'reporte_historico_completo_de_materia', nombre: 'verReporteHistoricoCompletoDeMateria')
	Permiso.find_or_create_by(clase: 'ReportePeriodo', accion: 'reporte_periodo_comparado_de_materia', nombre: 'verReportePeriodoComparadoDeMateria')
	Permiso.find_or_create_by(clase: 'ReportePeriodo', accion: 'reporte_periodo_completo_de_materia', nombre: 'verReportePeriodoCompletoDeMateria')

	# Permisos para consulta de reportes de docente
	Permiso.find_or_create_by(clase: 'ReporteHistorico', accion: 'reporte_historico_pregunta_de_docente', nombre: 'verReporteHistoricoDePreguntaEnDocente')
	Permiso.find_or_create_by(clase: 'ReporteHistorico', accion: 'reporte_historico_comparado_de_docente', nombre: 'verReporteHistoricoComparadoDeDocente')
	Permiso.find_or_create_by(clase: 'ReporteHistorico', accion: 'reporte_historico_completo_de_docente', nombre: 'verReporteHistoricoCompletoDeDocente')
	Permiso.find_or_create_by(clase: 'ReportePeriodo', accion: 'reporte_periodo_comparado_de_docente', nombre: 'verReportePeriodoComparadoDeDocente')
	Permiso.find_or_create_by(clase: 'ReportePeriodo', accion: 'reporte_periodo_completo_de_docente', nombre: 'verReportePeriodoCompletoDeDocente')
end