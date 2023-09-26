class Api::BaseController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
end
