class AddEstudianteHashSumToPeriodosAcademicos < ActiveRecord::Migration
  def change
  	change_table :periodos_academicos do |t|
	  t.rename :hash_sum, :asignaturas_hash_sum
      t.string :estudiantes_hash_sum, limit: 255, null: true
	end
  end
end
