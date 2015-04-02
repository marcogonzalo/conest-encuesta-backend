class ChangeValorTypeToIntegerInOpciones < ActiveRecord::Migration
  def self.up
    remove_column :opciones, :valor
    add_column :opciones, :valor, :integer
  end
 
  def self.down
    change_column :opciones, :valor, :string
  end
end
