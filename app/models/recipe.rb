class Recipe < ApplicationRecord
  has_many :rates

  def rating
    if rates.any?
      result = rates.sum(:rating).to_f / rates.size
      result.round(2)
    else
      0
    end
  end

  def details
    binary_data = recipe_details # Replace with how you retrieve it
    binary_data.force_encoding(Encoding::UTF_8)
  end
end
