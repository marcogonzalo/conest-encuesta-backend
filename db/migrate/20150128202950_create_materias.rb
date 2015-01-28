class CreateMaterias < ActiveRecord::Migration
  def change
    create_table :materias do |t|
      t.string :codigo, limit: 10, null: false, index: true, unique: true
      t.references :carrera, index: true
      t.string :plan_nombre, limit: 20, null: false
      t.string :nombre, limit: 255, null: false
      t.string :tipo_materia_id, limit: 10, null: false
      t.string :grupo_nota_id, limit: 10, null: false

      t.timestamps null: false
    end
    add_foreign_key :materias, :carreras
  end
end
