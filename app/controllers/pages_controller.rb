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
		@array= ChurchGroup.make_hash_month_sum("Jan", :sunday_att)
		@ldn_hash = ChurchGroup.make_hash_latest_ldn(:sunday_att)
		@ldn_hash["No Church"] = (User.find_by(id: 33).records.order('day DESC').first.sunday_att)-(ChurchGroup.where(region: "London").total_latest_ldn(:sunday_att))
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

def last_sunday_charts
	if current_user && current_user.admin
@date = date_of_last("Sunday")
@ldn_hash = ChurchGroup.make_hash_latest_ldn(:sunday_att)
@ldn_hash["No Church"] = (User.find_by(id: 33).records.order('day DESC').first.sunday_att)-(ChurchGroup.where(region: "London").total_latest_ldn(:sunday_att))
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

def time_series_charts
	if current_user && current_user.admin
@date = date_of_last("Sunday")
@ldn_hash = ChurchGroup.make_hash_latest_ldn(:sunday_att)
@ldn_hash["No Church"] = (User.find_by(id: 33).records.order('day DESC').first.sunday_att)-(ChurchGroup.where(region: "London").total_latest_ldn(:sunday_att))
	end
end

def monthly_average_charts
	if current_user && current_user.admin
@date = date_of_last("Sunday")
@ldn_hash = ChurchGroup.make_hash_latest_ldn(:sunday_att)
@ldn_hash["No Church"] = (User.find_by(id: 33).records.order('day DESC').first.sunday_att)-(ChurchGroup.where(region: "London").total_latest_ldn(:sunday_att))
	end
end

def visitation
@users = []
		User.where(admin: false).each do |t|
			if !t.records.last.visitation
				@users << t
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
