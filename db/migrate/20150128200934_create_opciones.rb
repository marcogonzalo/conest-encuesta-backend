class CreateOpciones < ActiveRecord::Migration
  def change
    create_table :opciones do |t|
      t.string :etiqueta, limit: 100, null: false
      t.string :valor, limit: 20, null: false
      t.references :pregunta, index: true

      t.timestamps null: false
    end
    add_foreign_key :opciones, :preguntas
  end
end
