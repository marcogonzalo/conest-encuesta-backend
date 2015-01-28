class CreatePeriodosAcademicos < ActiveRecord::Migration
  def change
    create_table :periodos_academicos do |t|
      t.string :periodo, limit: 10, null: false, index: true, unique: true
      t.string :hash_sum, limit: 255, null: true
      t.datetime :sincronizacion

      t.timestamps null: false
    end
  end
end
