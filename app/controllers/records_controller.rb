class RecordsController < ApplicationController

def index
	if current_user.admin
		@records= Record.all
end

#def new
#@record = current_user.records.new(record_params)
#end

 def create
    @record = Record.create(record_params)
   # if @record.save
    #  flash[:success] = "Data Recorded! Thank You #{current_user.elder}"
     # redirect_to root_url
    #else
     # @feed_items = []
     # render 'records/index'
    #end
  end
  
  def destroy
    @record.destroy
    flash[:success] = "Record deleted"
    redirect_to request.referrer || root_url
  end
  
  private
    
    def record_params
      params.require(:record).permit(:day, :sunday_att, :weekday_att, :first_timers, :new_converts, :nbs, :nbs_finish, :fnb, :message_sunday, :message_weekday, :preacher_sunday, :preacher_wekday, :user_id)
    end
    
    #def correct_user
      #@micropost = current_user.microposts.find_by(id: params[:id])
      #redirect_to root_url if @micropost.nil?
    #end

end
