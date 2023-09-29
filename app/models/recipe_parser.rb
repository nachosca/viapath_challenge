require 'nokogiri'

class RecipeParser
  def initialize(url)
    @url = url.gsub('http://', 'https://')
    begin
      conn = Faraday.new(url: @url) do |faraday|
        faraday.adapter Faraday.default_adapter
      end

      response = conn.get
      @document = Nokogiri::HTML(response.body)
    rescue StandardError => e
      puts(e.message)
    end
  end

  def title
    "Title: " + @document.css('h1').text
  end

  def about
    "About: " + @document.css('.about p').text
  end

  def recipe_yield
    "Yield: " + @document.css('[itemprop="recipeYield"]').text
  end

  def ingredients
    ingr = @document.css('[itemprop="ingredients"]').map(&:text)
    "Ingredients: " + ingr.join(", ")
  end

  def preparation
    preparation_steps = @document.css('.pane-node-field-rec-steps .step-body')
    # Iterate through the preparation steps and print their text
    prep = ''
    preparation_steps.each_with_index do |step, index|
      prep += "Step #{index + 1}: #{step.text.strip} "  # Use .strip to remove leading/trailing whitespace
    end
    "Preparation: " +  prep
  end

  def text
    title + ". " + about + ". " + recipe_yield + ". " + ingredients + ". " + preparation
  end

end
