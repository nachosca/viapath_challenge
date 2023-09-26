class Api::RatesController < Api::BaseController

  before_action :load_current_user  

  def create
    rate = Rate.new(permitted_params)

    rate.user = @current_user

    if rate.save
      render json: rate, status: :created
    else
      render json: { errors: rate.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def permitted_params
    params.require(:rate).permit(:rating, :recipe_id)
  end

  private 

  def load_current_user
    authenticate_user!

    @current_user = current_user
  end

end
