class UsersController < ApplicationController
   before_action :logged_in_user, only: [:index, :new, :create, :edit, :update, :show, :destroy]
  before_action :admin_user, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :correct_user_cg, only: [:show]
	helper_method :sort_column, :sort_direction
def index
  if params[:search]
    @users = User.search(params[:search]).where(admin: false).where(is_leader: false).order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 11) 
  else
    @users = User.where(admin: false).where(is_leader: false).order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 11) 

  end
  
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
      flash[:info] = "Church Successful Created!"
      redirect_to users_path
    else
      render 'new'
    end
  end

  def show
@user = User.find(params[:id])
@records = @user.records.paginate(page: params[:page], per_page: 20)
@max_record = @user.records.order('sunday_att DESC').first
@latest_record = @user.records.find_by(day: @user.date_of_last("Sunday") ) || @user.records.last
    end

  def update
  	@user = User.find(params[:id])
    
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
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
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end


  private

  def user_params
    params.require(:user).permit(:email, :name, :elder, :church_group_id, :password, :password_confirmation, :city, :is_leader)
  end

    def pwd_params
    params.require(:user).permit(:password, :password_confirmation)
  end


   def correct_user_cg
      @user = User.find(params[:id])
      redirect_to(demo_path) unless (current_user.is_leader && current_user.church_group == @user.church_group) || current_user.admin
    end

def logged_in_user
unless logged_in?
flash[:danger] = "Please log in."
redirect_to login_url
end
end

    def admin_user
      redirect_to demo_path unless current_user.admin?
    end


  def sort_column
   params[:sort] ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
