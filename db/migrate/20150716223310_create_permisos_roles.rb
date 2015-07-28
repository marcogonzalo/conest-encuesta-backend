class CreatePermisosRoles < ActiveRecord::Migration
  def change
  	create_join_table :permisos, :roles
  end
end
