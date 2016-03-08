class RecordsController < ApplicationController

def index
	if current_user.admin
		@records= Record.all
	end
end

def new
@record = current_user.records.new
end

def edit
end

 def create
    @record = current_user.records.build(record_params)
    if @record.save
      flash[:success] = "Data Recorded! Thank You #{current_user.elder}"
     redirect_to records_path
    else
     flash.now[:danger] = 'Error - Check Data'
     render 'new'
    end
  end
  
  def update
if @record.update_attributes(record_params)
      flash[:success] = "Record updated"
      redirect_to_users_path
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
      params.require(:record).permit(:day, :sunday_att, :weekday_att, :first_timers, :new_converts, :nbs, :nbs_finish, :fnb, :message_sunday, :message_weekday, :preacher_sunday, :preacher_wekday)
    end
    
    “rails generate migration add_reset_to_users reset_digest:string \
> reset_sent_at:datetime”

Excerpt From: Michael Hartl. “Ruby on Rails Tutorial.” iBooks. https://itun.es/gb/6AW96.l
 

end
