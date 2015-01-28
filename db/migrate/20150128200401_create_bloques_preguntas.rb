class CreateBloquesPreguntas < ActiveRecord::Migration
  def change
  	create_join_table :bloques, :preguntas
  end
end
