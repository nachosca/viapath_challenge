class Rate < ApplicationRecord
  belongs_to :user
  belongs_to :recipe

  validates :rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  validates :user_id, :recipe_id, :rating, presence: true
  validates_uniqueness_of :user, scope: [:recipe]
end
