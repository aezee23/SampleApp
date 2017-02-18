class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :new, :create, :edit, :update, :show, :destroy]
  before_action :admin_user, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :correct_user_account, only: [:show, :edit_my_profile]
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
    @user = params[:id] ? User.includes(:churches, :church_groups).find(params[:id]) : User.includes(:churches, :church_groups).find(current_user.id)
    @groups = @user.church_groups
    @churches = @user.churches
    @records = @user.records.limit(8)
  end

  def home
    @user = current_user
    @groups = @user.church_groups
    @churches = @user.churches
    @records = @user.records.limit(8)
    @members = current_user.members
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

  def edit_my_profile
    @user = User.find(params[:id])
  end

  def update_my_profile
    @user = current_user
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to home_path
    else
      flash[:danger] = "Please try again"
      render 'edit_my_profile'
    end
  end

  def remove_avatar
    # @user.remove_avatar!
    # @user.save ? render json: 'Done'.to_json : render json: 'Failed'.to_json
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
    params.require(:user).permit(:email, :name, :password, :password_confirmation, :admin, :role, :avatar)
  end

  def correct_user_account
    user = params[:id] ? User.find(params[:id]) : current_user
    redirect_to demo_path unless (current_user.admin? || current_user == user)
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
