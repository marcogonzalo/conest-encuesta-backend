class CreateBloquesInstrumentos < ActiveRecord::Migration
  def change
  	create_join_table :bloques, :instrumentos
  end
end
