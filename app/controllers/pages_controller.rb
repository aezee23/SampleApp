class PagesController < ApplicationController

  before_action :logged_in_user, only: [:index, :show, :last_sunday, :last_sunday_charts, :time_series_charts, :monthly_average_charts, :visitation]
  before_action :admin_user, only: [:show, :last_sunday, :last_sunday_charts, :time_series_charts, :monthly_average_charts, :visitation, :data_sheet, :visi_record]
	helper_method :sort_column, :sort_direction, :mweek
	helper_method :sun_in_month
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
		User.where(admin: false).where(is_leader: false).each do |t|
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
		User.where(admin: false).where(is_leader: false).each do |t|
		#	if t.records.count == 0
		#		@users << t
		#	else
			if !t.records.order('day DESC').first.visitation
				@users << t
			end
		end
end

def visi_record
@users = User.where(admin: false)
sd = Date.parse(Date.today.strftime("%Y0101"))
ed=Date.today
@dates = ed.downto(sd)
@months = @dates.map{|t| t.strftime("%b%y")}.uniq
months = @dates.map{|t| t.strftime("01%b%y")}.uniq
@weeks = months.map{|t| (Date.parse(t)..((Date.parse(t)>>1)-1))}

def sun_in_month(month)
b = (Date.parse("01#{month}")..((Date.parse("01#{month}"))>>1)-1).select{|y| y.wday==0}
b.length
end

	end

def data_sheet
@users = User.where(admin: false).where(is_leader: false)
@date_range= (Date.parse(Date.today.strftime("%Y0101"))..Date.today)
@dates=@date_range.select{|x| x.wday==0}
@months= ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
@cats= ["Sunday 1ST SERVICE", "Sunday 2NDSERVICE", "Sunday 3RD SERVICE", "Weekday", "Ministry", "New Con", "F-T", "F & B", "Children below 12 yrs" ]
@weeks = 1..5
end




private

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

end
