class PagesController < ApplicationController
	helper_method :sort_column, :sort_direction
	def index
		@date = date_of_last("Sunday").strftime('%d-%b-%y')
		@users = []
		User.where(admin: false).each do |t|
			if t.has_not_submitted
				@users << t
			end
		end

	end

	def show
		@date = date_of_last("Sunday").strftime('%d-%b-%y')
		@users = []
		User.where(admin: false).each do |t|
			if t.has_not_submitted
				@users << t
			end
		end

	end

def last_sunday
	if current_user && current_user.admin
@date = date_of_last("Sunday")
  if  request.format != "csv"
        @records= Record.where(day: date_of_last("Sunday")).order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 15)
      else
 @records= Record.where(day: date_of_last("Sunday"))
  respond_to do |format|
    format.html
    format.csv { send_data @records.to_csv }
    format.xls { render :xml => @records }
  end
  end
end
end

private

  def sort_column
    (params[:sort]) ? params[:sort] : "day"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

end
