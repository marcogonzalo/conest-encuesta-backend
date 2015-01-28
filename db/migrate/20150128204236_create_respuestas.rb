class CreateRespuestas < ActiveRecord::Migration
  def change
    create_table :respuestas do |t|
      t.references :consulta, index: true
      t.references :pregunta, index: true
      t.string :valor, limit: 45, null: false

      t.timestamps null: false
    end
    add_foreign_key :respuestas, :consultas
    add_foreign_key :respuestas, :preguntas
  end
end
