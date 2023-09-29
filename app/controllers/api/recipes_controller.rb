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
    api_key = '946d4e7ae4724067b144a1db22e80bbd'
    recipe_search_service = RecipeSearchService.new(api_key)

    if recipe_search_service.search_and_save(params[:query])
      render json: {}, status: :ok
    else
      render json: { error: 'Failed to fetch and save recipes' }, status: :unprocessable_entity
    end
  end

  private

  def permitted_params
    params.require(:model).permit(:query)
  end

end
