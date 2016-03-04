class UsersController < ApplicationController
	 def create
    @user= User.create(user_params)
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :elder, :church_group_id, :password, :password_confirmation)
  end
end
