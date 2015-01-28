class CreateOfertasPeriodo < ActiveRecord::Migration
  def change
    create_table :ofertas_periodo do |t|
      t.references :materia, index: true
      t.references :periodo_academico, index: true
      t.integer :docente_coordinador

      t.timestamps null: false
    end
    add_foreign_key :ofertas_periodo, :materias
    add_foreign_key :ofertas_periodo, :periodos_academicos
  end
end
