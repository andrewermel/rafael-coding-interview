class UsersController < ApplicationController

  def index
    users = User.all
    users = users.by_company(params[:company_identifier]) if params[:company_identifier].present?
    users = users.by_username(search_params[:username]) if search_params[:username].present?
  
    render json: users
  end
  

  private

  def search_params
    params.permit(:username)
  end

end
