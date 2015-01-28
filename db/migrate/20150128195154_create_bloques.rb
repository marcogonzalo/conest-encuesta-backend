class CreateBloques < ActiveRecord::Migration
  def change
    create_table :bloques do |t|
      t.string :nombre, limit: 100, null: false
      t.string :descripcion, limit: 255, null: true
      t.string :tipo, limit: 4, null: false

      t.timestamps null: false
    end
  end
end
