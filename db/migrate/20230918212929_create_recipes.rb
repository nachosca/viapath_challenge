class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.integer :recipe_id
      t.integer :ready_in_minutes
      t.string :source_url
      t.integer :servings
      t.string :image
      t.string :title

      t.binary :recipe_details

      t.timestamps
    end
  end
end
