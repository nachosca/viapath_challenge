# app/services/recipe_search_service.rb
class RecipeSearchService
  def initialize(api_key)
    @api_key = api_key
    @base_url = 'https://api.spoonacular.com'
  end

  def search_and_save(query)
    offset = 0
    results = []

    begin
      loop do
        conn = Faraday.new(url: @base_url) do |faraday|
          faraday.request :url_encoded
          faraday.adapter Faraday.default_adapter
        end

        # Build the GET request
        response = conn.get '/recipes/search' do |req|
          req.params['query'] = query
          req.params['apiKey'] = @api_key
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

      true
    rescue StandardError => e
      puts(e.message)
      false
    end
  end

  private

  def save_recipe(response_recipe)
    recipe = Recipe.find_or_initialize_by(recipe_id: response_recipe['id'])

    recipe.assign_attributes(
      ready_in_minutes: response_recipe['readyInMinutes'],
      source_url: response_recipe['sourceUrl'],
      image: response_recipe['image'],
      servings: response_recipe['servings'],
      title: response_recipe['title']
    )

    recipe.save!
    recipe
  end
end
