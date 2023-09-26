class Recipe < ApplicationRecord
  has_many :rates

  def details
    recipe_details.open do |file|
      file.read
    end
  end

  def rating
    if rates.any?
      rates.sum(:rating) / rates.size
    else
      0
    end
  end
end
