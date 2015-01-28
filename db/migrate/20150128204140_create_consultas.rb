class CreateConsultas < ActiveRecord::Migration
  def change
    create_table :consultas do |t|
      t.references :oferta_academica, index: true
      t.references :instrumento, index: true

      t.timestamps null: false
    end
    add_foreign_key :consultas, :oferta_academica
    add_foreign_key :consultas, :instrumentos
  end
end
