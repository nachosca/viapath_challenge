class Api::RecipesController < Api::BaseController

  require 'faraday'
  require 'json'

  before_action :authenticate_user!

  def get_by_ids
    recipe_ids = params[:ids]
    @recipes = Recipe.where(recipe_id: recipe_ids)

    if @recipes.any?
      render json: {
        recipes: ActiveModelSerializers::SerializableResource.new(@recipes, each_serializer: RecipeSerializer)
      }
    else
      render json: { message: 'No recipes found' }, status: :not_found
   end
  end


  def search
    byebug
    # Create a Faraday connection
    base_url = 'https://api.spoonacular.com'
    api_key = 'fb3e49784d1e48c880e2b5ae82ea90a8'
    conn = Faraday.new(url: base_url) do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end

    # Build the GET request
    response = conn.get '/recipes/search' do |req|
      req.params['query'] = params[:query]
      req.params['apiKey'] = api_key
    end

    # Handle the response
    if response.status == 200
      parsed_response = JSON.parse(response.body)

      parsed_response.results.each do |response_recipe|
        save_recipe(response_recipe)
        RecipeDetailsWorker.perform_async(response_recipe.id, response_recipe.source_url)
      end

      render json: {
        recipes: ActiveModelSerializers::SerializableResource.new(response_recipe, each_serializer: RecipeSerializer)
      }, status: :ok
    else
      render json: { error: "Request failed with status #{response.status}" }, status: :unprocessable_entity
    end
  end

  private

  def model_params
    params.require(:model).permit(:query)
  end

  def save_recipe(response_recipe)
    recipe = Recipe.find_by(recipe_id: response_recipe[:id])
        
    if recipe
      recipe.update(ready_in_minutes: response_recipe.readyInMinutes,
                    source_url: response_recipe.sourceUrl,
                    image: response_recipe.image,
                    servings: response_recipe.servings,
                    title: response_recipe.title)
    else
      Recipe.create(
        recipe_id: response_recipe.id,
        ready_in_minutes: response_recipe.readyInMinutes,
        source_url: response_recipe.sourceUrl,
        image: response_recipe.image,
        servings: response_recipe.servings,
        title: response_recipe.title)
    end
  end

end
