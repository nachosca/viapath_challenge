class CreateRates < ActiveRecord::Migration[7.0]
  def change
    create_table :rates do |t|
      t.integer :rating
      t.belongs_to :user
      t.belongs_to :recipe

      t.timestamps
    end

    add_index :rates, [:user_id, :recipe_id], unique: true

  end
end
