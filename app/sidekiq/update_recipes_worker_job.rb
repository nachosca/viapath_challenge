class UpdateRecipesWorkerJob
  include Sidekiq::Job

  def perform

    base_url = 'https://api.spoonacular.com'
    api_key = '946d4e7ae4724067b144a1db22e80bbd'
    conn = Faraday.new(url: base_url) do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end

    begin
      Recipe.find_each do |recipe|

        # Build the GET request
        response = conn.get "/recipes/#{recipe.recipe_id}/information" do |req|
          req.params['apiKey'] = api_key
        end

        # Handle the response
        if response.status == 200
          parsed_response = JSON.parse(response.body)
          update_recipe(recipe, parsed_response)
        else
          puts "Request failed with status #{response.status}"
        end
      end
    rescue StandardError => e
      puts('Error ' + e.message)
    end

  end

  private

  def update_recipe(recipe, response_recipe)        
    if recipe
      recipe.update!(ready_in_minutes: response_recipe['readyInMinutes'],
                    source_url: response_recipe['sourceUrl'],
                    image: response_recipe['image'],
                    servings: response_recipe['servings'],
                    title: response_recipe['title'])
    end
  end

end
