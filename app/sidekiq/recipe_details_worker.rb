class RecipeDetailsWorker
  include Sidekiq::Worker

  def perform(id, source_url)
    recipe_details = RecipeParser.new(source_url)

    begin
      file = recipe_details.text.encode(Encoding::UTF_8)

      recipe = Recipe.find(id)

      if recipe
        recipe.recipe_details = file
        recipe.save
      end
    rescue StandardError => e
      puts(e.message)
    end

  end
end