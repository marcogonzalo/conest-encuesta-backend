after 'permisos' do
	rol = Rol.find_by(nombre: 'SuperAdmin')
	rol.permisos.destroy_all
	rol.permisos << Permiso.find_by(nombre: 'accesoTotal')
	rol = nil

	rol = Rol.find_by(nombre: 'Admin')
	rol.permisos.destroy_all
	rol.permisos << Permiso.find_by(nombre: 'listarPeriodos')
	rol.permisos << Permiso.find_by(nombre: 'crearPeriodo')
	rol.permisos << Permiso.find_by(nombre: 'sincronizarPeriodo')
	rol.permisos << Permiso.find_by(nombre: 'sincronizarEstudiantes')
	rol.permisos << Permiso.find_by(nombre: 'listarInstrumentos')
	rol.permisos << Permiso.find_by(nombre: 'verInstrumento')
	rol.permisos << Permiso.find_by(nombre: 'crearInstrumento')
	rol.permisos << Permiso.find_by(nombre: 'editarInstrumento')
	rol.permisos << Permiso.find_by(nombre: 'eliminarInstrumento')
	rol = nil

	rol = Rol.find_by(nombre: 'Estudiante')
	rol.permisos.destroy_all
	rol.permisos << Permiso.find_by(nombre: 'verInstrumento')
	rol.permisos << Permiso.find_by(nombre: 'listarPeriodos')
	rol.permisos << Permiso.find_by(nombre: 'listarConsultasSinResponder')
	rol.permisos << Permiso.find_by(nombre: 'responderConsultas')
	rol.permisos << Permiso.find_by(nombre: 'listarReportes')
	rol.permisos << Permiso.find_by(nombre: 'verReporteHistoricoDePreguntaEnDocente')
	rol.permisos << Permiso.find_by(nombre: 'verReporteHistoricoComparadoDeDocente')
	rol.permisos << Permiso.find_by(nombre: 'verReporteHistoricoCompletoDeDocente')
	rol.permisos << Permiso.find_by(nombre: 'verReportePeriodoComparadoDeDocente')
	rol.permisos << Permiso.find_by(nombre: 'verReportePeriodoCompletoDeDocente')
	rol = nil

	rol = Rol.find_by(nombre: 'Docente')
	rol.permisos.destroy_all
	rol.permisos << Permiso.find_by(nombre: 'verInstrumento')
	rol.permisos << Permiso.find_by(nombre: 'listarPeriodos')
	rol.permisos << Permiso.find_by(nombre: 'listarReportes')
	rol.permisos << Permiso.find_by(nombre: 'verReporteHistoricoDePreguntaEnDocente')
	rol.permisos << Permiso.find_by(nombre: 'verReporteHistoricoComparadoDeDocente')
	rol.permisos << Permiso.find_by(nombre: 'verReporteHistoricoCompletoDeDocente')
	rol.permisos << Permiso.find_by(nombre: 'verReportePeriodoComparadoDeDocente')
	rol.permisos << Permiso.find_by(nombre: 'verReportePeriodoCompletoDeDocente')
	rol = nil
end