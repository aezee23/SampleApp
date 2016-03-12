class RecordsController < ApplicationController
helper_method :sort_column, :sort_direction
def index
	if current_user && current_user.admin
	if  request.format != "csv"
        @records= Record.all.order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 30)
      else

		@records= Record.all.order(sort_column + " " + sort_direction)
	
	respond_to do |format|
    format.html
    format.csv { send_data @records.to_csv }
    format.xls # { send_data @recordss.to_csv(col_sep: "\t") }
  end
end
	elsif current_user && !current_user.admin
		@records= current_user.records.all.order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 13) 
	
	end

end

def new
@record = current_user.records.new
@date = date_of_last("Sunday")
end

def edit
	@record = Record.find(params[:id])
end


 def create
   @record = current_user.records.build(record_params)
    if @record.save
      flash[:success] = "Data Recorded! Thank You #{current_user.elder}"
     redirect_to records_path
    else
     flash.now[:danger] = 'Error - See Below'
     render 'new'
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
  
    def show
@record = Record.find(params[:id])
    end



  private
    
    def record_params
      params.require(:record).permit(:day, :sunday_att, :weekday_att, :first_timers, :new_converts, :nbs, :nbs_finish, :fnb, :message_sunday, :message_weekday, :preacher_sunday, :preacher_weekday, :user_id)
    end
    
  def sort_column
    (params[:sort]) ? params[:sort] : "day"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
 

end
