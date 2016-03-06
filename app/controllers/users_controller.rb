class UsersController < ApplicationController
	
def index
  if params[:search]
    @users = User.search(params[:search]).where(admin: false).order("name ASC")
  else
    @users = User.where(admin: false).order('name ASC')
  end
end


	def create
    @user= User.create(user_params)
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :elder, :church_group_id, :password, :password_confirmation)
  end
end
