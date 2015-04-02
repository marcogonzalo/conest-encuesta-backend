class ChangeValorTypeToIntegerInRespuestas < ActiveRecord::Migration
  def self.up
    remove_column :respuestas, :valor
    add_column :respuestas, :valor, :integer
  end
 
  def self.down
    change_column :respuestas, :valor, :string
  end
end
