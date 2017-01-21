class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :new, :create, :edit, :update, :show, :destroy]
  before_action :admin_user, only: [:index, :new, :create, :edit, :update, :destroy, :show]
	helper_method :sort_column, :sort_direction

  def index
    @users = User.order(role: :asc)
  end

  def new
    @user = User.new
  end

  def edit
  	@user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:info] = "User Successful Created!"
      redirect_to users_path
    else
      render 'new'
    end
  end

  def show
    redirect_to users_path
    @user = User.find(params[:id])
    @church_groups = @user.church_groups
    @churches = @user.churches
  end

  def update
  	@user = User.find(params[:id])    
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to users_path
    else
    	 flash[:danger] = "Please try again"
      render 'edit'
    end
  end

  def change_pwd
    @user = current_user
    if @user.update_attributes(pwd_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      flash[:danger] = "Please try again"
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    user.visitation_records.destroy_all
    user.destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation, :admin, :role)
  end

  def pwd_params
    params.require(:user).permit(:password, :password_confirmation)
  end


  def sort_column
   params[:sort] ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
