class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :nombre, index: true, null: false
      t.string :descripcion
    end
  end
end
