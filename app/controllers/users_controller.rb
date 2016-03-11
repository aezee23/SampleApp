class UsersController < ApplicationController
	
def index
  if params[:search]
    @users = User.search(params[:search]).where(admin: false).order("name ASC").paginate(page: params[:page], per_page: 10) 
  else
    @users = User.where(admin: false).order('name ASC').paginate(page: params[:page], per_page: 10) 

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
      flash[:info] = "Please check your email to activate your account."
      redirect_to_users_path
    else
      render 'new'
    end
  end

  def show
@user = User.find(params[:id])
@records = @user.records.paginate(page: params[:page])
    end

  def update
    if @user.update_attributes(user_params)
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
    params.require(:user).permit(:email, :name, :elder, :church_group_id, :password, :password_confirmation)
  end

   def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(current_user) unless current_user.admin?
    end
end
