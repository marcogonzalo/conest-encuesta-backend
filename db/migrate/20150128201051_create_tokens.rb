class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :token, limit: 45, null: false
      t.string :hash_sum, limit: 255, null: true

      t.timestamps null: false
    end
  end
end
