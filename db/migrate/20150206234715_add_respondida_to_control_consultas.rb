class AddRespondidaToControlConsultas < ActiveRecord::Migration
  def change
  	change_table :control_consultas do |t|
  		t.boolean :respondida, default: false
  	end
  end
end
