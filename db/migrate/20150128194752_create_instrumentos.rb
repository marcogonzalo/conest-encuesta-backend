class CreateInstrumentos < ActiveRecord::Migration
  def change
    create_table :instrumentos do |t|
      t.string :nombre, limit: 100, null: false
      t.string :descripcion, limit: 255, null: true

      t.timestamps null: false
    end
  end
end
