class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :nombre, index: true
      t.string :descripcion

      t.timestamps null: false
    end
  end
end
