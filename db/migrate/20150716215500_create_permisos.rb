class CreatePermisos < ActiveRecord::Migration
  def change
    create_table :permisos do |t|
    	t.string :clase, null: false, index: true
    	t.string :accion, null: false, index: true
    	t.string :nombre, null: false, index: true
    	t.string :descripcion

    	t.timestamps null: false
    end
  end
end
