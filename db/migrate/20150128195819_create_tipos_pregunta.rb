class CreateTiposPregunta < ActiveRecord::Migration
  def change
    create_table :tipos_pregunta do |t|
      t.string :nombre, limit: 45, null: false
      t.string :valor, limit: 45, null: false
      t.string :valor_html, limit: 45, null: false

      t.timestamps null: false
    end
  end
end
