class RecipeDetailsWorker
  include Sidekiq::Worker

  def perform(id, source_url)
    recipe_details = RecipeParser.new(source_url)

    file = File.write('my_file.txt', recipe_details.text, encoding: 'UTF-8')

    recipe = Recipe.find_by(recipe_id: id)

    if recipe
      recipe.recipe_details = file
      recipe.save
    end


  end
end