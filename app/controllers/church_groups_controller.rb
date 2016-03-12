class ChurchGroupsController < ApplicationController
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
  end

    def update
    if @church_group.update(church_params)
      redirect_to church_groups_path, notice: 'Church Group was successfully updated.'
    else
      render action: 'edit'
    end
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

end
