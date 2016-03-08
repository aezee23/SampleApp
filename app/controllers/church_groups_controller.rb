class ChurchGroupsController < ApplicationController
	 def index
@church_group = ChurchGroup.where.not(id: 1).order('name ASC')
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
end
