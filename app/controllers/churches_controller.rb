class ChurchesController < ApplicationController
    before_action :logged_in_user, only: [:index, :new, :create, :edit, :update, :show, :destroy]
    before_action :admin_user, only: [:index, :new, :create, :edit, :update, :destroy]
    before_action :correct_user_cg, only: [:show]
    helper_method :sort_column, :sort_direction
  def index
    if params[:search]
      @churches = Church.search(params[:search]).order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 11) 
    else
      @churches = Church.order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 11) 
    end  
  end

  def new
    @church = Church.new
  end

  def edit
    @church = Church.find(params[:id])
  end

  def create
    @church = Church.new(church_params)
    if @church.save
      flash[:info] = "Church Successful Created!"
      redirect_to churches_path
    else
      render 'new'
    end
  end

  def show
    @church = Church.find(params[:id])
    @records = @church.records.paginate(page: params[:page], per_page: 20)
    @max_record = @church.records.find_by(sunday_att: @church.records.pluck(:sunday_att).max)
    @latest_record = @church.records.find_by(day: date_of_last("Sunday") ) || @church.records.order('day DESC').first
  end

  def update
    @church = Church.find(params[:id])
    
    if @church.update_attributes(church_params)
      flash[:success] = "Church updated"
      redirect_to @church
    else
       flash[:danger] = "Please try again"
      render 'edit'
    end
  end

  def destroy
    @church = Church.find(params[:id])
    @church.records.destroy_all
    @church.destroy
    flash[:success] = "Church deleted"
    redirect_to churches_url
  end


  private

  def church_params
    params.require(:church).permit!
  end

  def sort_column
   params[:sort] ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def correct_user_cg
    @church = Church.find(params[:id])
    redirect_to(demo_path) unless current_user.church_groups.include?(@church.church_group) || current_user.admin
  end
end