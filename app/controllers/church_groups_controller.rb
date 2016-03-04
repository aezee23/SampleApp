class ChurchGroupsController < ApplicationController
	 def create
    @church_group= ChurchGroup.create(church_params)
  end

  private

  def church_params
    params.require(:church_group).permit(:name, :leader, :region)
  end
end
