class CreateControlConsultas < ActiveRecord::Migration
  def change
  	create_join_table :estudiantes, :oferta_academica, table_name: "control_consultas"
  end
end
