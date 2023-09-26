class RecipeSerializer < ActiveModel::Serializer
  attributes :id, :recipe_id, :ready_in_minutes, :source_url, :servings, :image, :title, :rating, :details

  def rating
    object.rating
  end

  def details
    object.details
  end


end