class CreateDocentes < ActiveRecord::Migration
  def change
    create_table :docentes do |t|
      t.string :cedula, limit: 20, index: true, unique: true
      t.string :primer_nombre, limit: 45, null: false
      t.string :segundo_nombre, limit: 45, null: true
      t.string :primer_apellido, limit: 45, null: false
      t.string :segundo_apellido, limit: 45, null: true

      t.timestamps null: false
    end
  end
end
