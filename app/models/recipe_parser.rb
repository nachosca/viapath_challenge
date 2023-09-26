class RecipeParser
  def initialize(url)
    @url = url
    @document = Nokogiri::HTML(open(@url))
  end

  def title
    "Title: " + @document.css('h1').map(&:text)
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
    prep = @document.css('[itemprop="recipeInstructions"]').map { |text| text.gsub(/<a.*?>|<\/a>/, '') }
    "Preparation: " +  prep.join(", ")
  end

  def text
    title + ". " + about + ". " + recipe_yield + ". " + ingredients + ". " + preparation
  end

end
