class ChurchGroupsController < ApplicationController
  before_action :logged_in_user, only: [:index, :new, :create, :edit, :update, :show, :destroy]
  before_action :admin_user, only: [:index, :new, :create, :edit, :update, :show, :destroy]

helper_method :sort_column, :sort_direction


	 def index
@church_groups = ChurchGroup.where.not(id: 1).order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 13)
@user= ChurchGroup.find_by(id: 10).users.first
	 end


 def new
    @church_group = ChurchGroup.new
  end
	 
	 def create
    @church_group= ChurchGroup.new(church_params)
        if @church_group.save
      redirect_to church_groups_path , notice: 'Church Group was successfully created.'
    else
      render action: 'new'
    end
  end

  def edit
  	@church_group = ChurchGroup.find(params[:id])
  end

    def update
    	@church_group = ChurchGroup.find(params[:id])
    if @church_group.update(church_params)
     flash[:success] = 'Church Group was successfully updated.'
redirect_to church_groups_path
    else
      render action: 'edit'
    end
  end

def show
@church_group = ChurchGroup.find(params[:id])
@users = @church_group.users
@max= @church_group.make_hash_time_series(:sunday_att).max[1]
end

def destroy
    ChurchGroup.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

  def church_params
    params.require(:church_group).permit(:name, :leader, :region)
  end

    def sort_column
   params[:sort] ? params[:sort] : "region"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
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
 

end
