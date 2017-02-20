class RecordsController < ApplicationController
  before_action :logged_in_user, only: [:index, :new, :create, :edit, :update, :show, :destroy]
  before_action :allowed_user, only: [:edit, :update, :destroy]
  before_action :correct_user_cg, only: [:show]
  helper_method :sort_column, :sort_direction
  def index
  	if current_user && current_user.admin
  	  if request.format != "csv"
        @records= Record.order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 30)
      else
    		@records= Record.order(sort_column + " " + sort_direction)
        # @records = Record.pluck(:day, :church_id, :sunday_att).map{ |arr| [arr[0], Church.find(arr[1]).name, arr[2]]}
      	respond_to do |format|
          format.html
          format.csv { send_data @records.to_csv }
          format.xls # { send_data @recordss.to_csv(col_sep: "\t") }
        end
      end
  	elsif current_user && !current_user.admin
  		@records = current_user.records.order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 13)	
    end
  end

  def data_download
    start_date = params[:start] ? Date.parse(params[:start]) : Date.today.beginning_of_month
    end_date = params[:end_date] ? Date.parse(params[:end_date]) : Date.today
    @sundays = (start_date..end_date).select { |date| date.wday == 0 }
    @n = @sundays.count == 0 ? 1 : @sundays.count
    @churches = Church.includes(:records).where('records.day' => start_date..end_date).sort{|x, y| x.name <=> y.name}
  end

    def show
    	@record = Record.find(params[:id])
    end

  def new
    if current_user.admin
      @record = Record.new
      @date = date_of_last("Sunday")
    else
      @record = current_user.records.new
      @date = date_of_last("Sunday")
    end
  #Record.create(record_params)
  end

  def edit
  	@record = Record.find(params[:id])
  end

  def create
    if current_user.admin
      @record = Record.new(record_params)
      if @record.save
        flash[:success] = "Data Recorded! Thank You #{current_user.name.split[0]}"
        redirect_to records_path
        VisitationRecord.create(visitation_params)
      else
       flash.now[:danger] = 'Error - See Below'
       render 'new'
      end
    else
     @record = current_user.records.build(record_params)
      if @record.save
        flash[:success] = "Data Recorded! Thank You #{current_user.name}"
        current_user.visitation_records.build(visitation_params).save
        if !current_user.is_leader?
          redirect_to records_path
        else
          redirect_to demo_path
        end
      else
       flash.now[:danger] = 'Error - See Below'
       render 'new'
      end
    end
  end
  
  def update
  @record = Record.find(params[:id])
if @record.update_attributes(record_params)
      flash[:success] = "Record updated. See All Records Below:"
      redirect_to records_path
    else
    	 flash[:danger] = "Please try again"
      render 'edit'
    end
  end

  def destroy
    @record.destroy
    flash[:success] = "Record deleted"
    redirect_to request.referrer || root_url
  end
  




  private
    
  def record_params
    params.require(:record).permit(:day, :sunday_att, :weekday_att, :first_timers, :new_converts, :nbs, :nbs_finish, :fnb, :message_sunday, :message_weekday, :preacher_sunday, :preacher_weekday, :user_id, :church_id, :baptised, :visitation)
  end

  def visitation_params
    params.require(:record).permit(:day, :user_id, :visitation)
  end
    
  def sort_column
    (params[:sort]) ? params[:sort] : "day"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
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

  def allowed_user
    @record = Record.find(params[:id])
    redirect_to home_path unless ( @record.is_editable? && current_user.can_edit_record(@record) ) || current_user.admin?
  end


  def correct_user
    @user = Record.find(params[:id]).user
    redirect_to demo_path unless current_user?(@user) || current_user.admin
  end

  def correct_user_cg
      @record = Record.find(params[:id])
      @cg = @record.church.church_group
      redirect_to(demo_path) unless (current_user.is_leader? && current_user.church_group == @cg) || current_user.admin
  end

end
