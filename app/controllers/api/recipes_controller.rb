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
    # Create a Faraday connection
    base_url = 'https://api.spoonacular.com'
    api_key = 'e612d78f890949d18d8ddcb41a682c5d'


    offset = 0
    results = []

    begin
      loop do
        conn = Faraday.new(url: base_url) do |faraday|
          faraday.request :url_encoded
          faraday.adapter Faraday.default_adapter
        end

        # Build the GET request
        response = conn.get '/recipes/search' do |req|
          req.params['query'] = params[:query]
          req.params['apiKey'] = api_key
          req.params['number'] = 100
          req.params['offset'] = offset
        end

        parsed_response = JSON.parse(response.body)

        results << parsed_response['results']

        offset += 100

        break if offset >= parsed_response['totalResults']
      end

      results = results.flatten
    
      results.each do |response_recipe|
        recipe = save_recipe(response_recipe)
        RecipeDetailsWorker.perform_async(recipe.id, recipe.source_url)
      end

      render json: {}, status: :ok
    rescue StandardError => e
      puts(e.message)
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  private

  def model_params
    params.require(:model).permit(:query)
  end

  def save_recipe(response_recipe)
    recipe = Recipe.find_by(recipe_id: response_recipe['id'])
        
    if recipe
      if recipe.update!(ready_in_minutes: response_recipe['readyInMinutes'],
                    source_url: response_recipe['sourceUrl'],
                    image: response_recipe['image'],
                    servings: response_recipe['servings'],
                    title: response_recipe['title'])
        return Recipe.find_by(recipe_id: response_recipe['id'])
      end
    else
      return Recipe.create(
        recipe_id: response_recipe['id'],
        ready_in_minutes: response_recipe['readyInMinutes'],
        source_url: response_recipe['sourceUrl'],
        image: response_recipe['image'],
        servings: response_recipe['servings'],
        title: response_recipe['title'])
    end
  end

end
