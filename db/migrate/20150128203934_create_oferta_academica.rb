class CreateOfertaAcademica < ActiveRecord::Migration
  def change
    create_table :oferta_academica do |t|
      t.references :oferta_periodo, index: true
      t.string :nombre_seccion, limit: 10, null: false
      t.references :docente, index: true
      t.string :promedio_general, limit: 45, null: true
      t.integer :nro_estudiantes, limit: 4, null: true
      t.integer :nro_estudiantes_retirados, limit: 4, null: true
      t.integer :nro_estudiantes_aprobados, limit: 4, null: true
      t.integer :nro_estudiantes_equivalencia, limit: 4, null: true
      t.integer :nro_estudiantes_suficiencia, limit: 4, null: true
      t.integer :nro_estudiantes_reparacion, limit: 4, null: true
      t.integer :nro_estudiantes_aplazados, limit: 4, null: true
      t.string :tipo_estatus_calificacion_id, limit: 10, null: true

      t.timestamps null: false
    end
    add_foreign_key :oferta_academica, :ofertas_periodo
    add_foreign_key :oferta_academica, :docentes
  end
end
