class PagesController < ApplicationController

  before_action :logged_in_user, only: [:index, :show, :last_sunday, :last_sunday_charts, :time_series_charts, :monthly_average_charts, :visitation, :retention]
  before_action :admin_user, only: [:show, :last_sunday, :last_sunday_charts, :time_series_charts, :monthly_average_charts, :visitation, :data_sheet, :visi_record]
	helper_method :sort_column, :sort_direction, :mweek
	helper_method :sun_in_month
	def index
    redirect_to home_path unless current_user.admin
    churches = Church.includes(:church_group)
    @churches = churches.map(&:name).sort
    @regions = churches.map(&:church_group).map(&:region).uniq.sort
    @cities = churches.map(&:city).uniq.sort
    @church_groups = churches.map(&:church_group).uniq
    @sunday_churches = churches.select(&:sunday_meeting).map{ |church| church.name.gsub('The University of', '').gsub('University of', '').gsub('()', '').strip }.sort
    @campuses = churches.select{ |church| !church.sunday_meeting }.map{ |church| church.name.gsub('The University of', '').gsub('University of', '').gsub('()', '').strip }.sort
    @times = last_twelve_months
	end

  def send_email
  #   users = User.all.select{ |user| !user.just_admin? }
  #   users.each do |user|
  #     UserMailer.welcome_email(user).deliver
  #   end

    # UserMailer.welcome_email(User.find(13)).deliver
    UserMailer.welcome_email(User.find(12)).deliver_later
    render json: "All Done".to_json
  end

	def show
		@date = date_of_last("Sunday").strftime('%d-%b-%y')
		@churches = Church.all.select{ |church| church.missing_data? }
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
  if params[:church_group] && params[:church_group] != "Church Group Leaders"
    @users = ChurchGroup.where(region: params[:church_group].split(" ")[0]).each_with_object([]) {|group, array| array << group.churches.map(&:elder)}.flatten.uniq
  elsif params[:church_group] == "Church Group Leaders"
    @users = ChurchGroup.order(region: :asc).map(&:user).uniq
  else
    @users = User.where.not(role: "Admin").order(name: :asc)
  end

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
@users = User.where(admin: false).where(is_leader: false).order('id ASC')
@date_range= (Date.parse(Date.today.strftime("%Y0101"))..Date.today)
@dates=@date_range.select{|x| x.wday==0}
@months= ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
@cats= ["Sunday 1ST SERVICE", "Sunday 2NDSERVICE", "Sunday 3RD SERVICE", "Weekday", "Ministry", "New Con", "F-T", "F & B", "Children below 12 yrs" ]
@weeks = 1..5
end

def retention

end




private

def last_twelve_months
  months = (Date.today.last_year..Date.today).map{|day| day.strftime("%b%Y")}.uniq.reverse
  array = [["Last 12 months", "Past Year"], ["Latest Data", "Latest Data"]]
  for i in 0..10
    array << [months[i + 1], "#{months[i + 1]} - #{months[i]}"] 
  end
  array
end

def make_total_hash
  @total_hash[Date.parse(month(2)).strftime('%b-%y')] = totals(month(2), month(1))
  @total_hash[Date.parse(month(1)).strftime('%b-%y')] = totals(month(1), month(0))
  @total_hash[Date.parse(month(0)).strftime('%b-%y')] = totals(month(0), month(-1))
  @total_hash[Date.today.strftime("%Y")] = totals(Date.today.strftime("Jan%Y"), month(-1))
end

def totals(records=@records, start_month, end_month)
  attrs = [:sunday_att, :new_converts, :first_timers, :nbs, :nbs_finish, :fnb]
  results = {}
  recs = records.select{ |record| record.church.sunday_meeting }
          .select{ |record| (Date.parse(start_month)..(Date.parse(end_month))-1).include?(record.day) }
  attrs.each { |attribute| results[attribute] = recs.map(&attribute).inject(&:+) }
  results[:n] = recs.map(&:day).uniq.count.to_f
  results
end

def latest_totals(region=nil, records=@records)
  attrs = [:sunday_att, :new_converts, :first_timers, :nbs, :nbs_finish, :fnb]
  results = {}
  if region
    recs = records.select{ |record| record.church.sunday_meeting }
                  .select{ |record| record.church.church_group.region == region }
                  .select{ |record| record.day == date_of_last("Sunday") }
  else
    recs = records.select{ |record| record.church.sunday_meeting }
                  .select{ |record| record.day == date_of_last("Sunday") }
  end
  attrs.each { |attribute| results[attribute] = recs.map(&attribute).inject(&:+) }
  results
end

def averages(records=@records, start_month, end_month)
  sums = totals(records, start_month, end_month)
  sums.each { |key, value| sums[key] = (value / sums[:n]).round(0) }
  sums
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

end
