class CreateUsuarios < ActiveRecord::Migration
  def change
    create_table :usuarios do |t|
      t.string :cedula, limit: 20, index: true, unique: true, null: false
      t.string :clave, limit: 100
      t.references :rol, index: true, foreign_key: true
      t.string :token, index: true

      t.timestamps null: false
    end
  end
end
