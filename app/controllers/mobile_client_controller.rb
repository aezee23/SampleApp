class MobileClientController < ApplicationController
  before_action :check_access, except: [:unauthorised]

  def avg(rec)
    rec.reduce(:+) / 5.0
  end

  def summary
    @results = {}
    prepare_summary
    render json: @results
  end

  def unauthorised
    render json: "Access denied"
  end


  def prepare_summary
    @records ||= Record.includes( church: [:church_group] ).where(
      day: (Date.today.last_year.beginning_of_year..Date.today)
      )
    @results[:totals] = prepare_totals(@records.select{ |record| record.church.sunday_meeting })
    @results[:totals_by_region] = total_for_region
    @results[:totals_by_group] = total_for_church_group
    @results[:totals_by_city] = total_for_city
    @results[:totals_by_church] = total_for_church
    @results[:totals_by_campus] = total_for_campuses
    @results[:information] = prepare_info
    @results[:pastors] = User.where.not(role: "Admin").map{ |user| [user.name, user.name.split(" ").reverse.join("").downcase] }
    @results[:churches] = Church.all.map { |church| [church.name, church.church_group.name, church.elder.name, church.elder.name.split(" ").reverse.join("").downcase] }
  end

  def prepare_totals(records)
    months = (Date.today.last_year..Date.today).map{|day| day.strftime("%b%Y")}.uniq.reverse
    results = {}
    results["Last 12 months"] = totals(records, months[12], months[0])
    months.each do |month|
      next_month = (Date.parse(month) >> 1).strftime("%b%Y")
      results[month] = totals(records, month, next_month)
    end
    results["Latest Data"] = totals(records.select{ |record| record.day == date_of_last("Sunday") }, months[0], (Date.parse(months[0]) >> 1).strftime("%b%Y") )
    results["Latest Data"]["month"] = "Latest Data"
    results["Latest Data"]["date"] = date_of_last("Sunday").strftime("%d%b%y")

    results
  end

  def total_for_church_group
    groups = @records.map(&:church).uniq.map(&:church_group).uniq.sort{|x, y| x.leader.name<=>y.leader.name}
    results = {}
    groups.each do |group|
      records = @records.select { |record| record.church.church_group == group }
      results[group.leader.name.split(" ")[0] + " - " + group.name] = prepare_totals(records)
    end
    results
  end

  def total_for_church
    groups = @records.map(&:church).uniq.select{ |church| church.sunday_meeting }.sort{|x, y| x.name.gsub('The University of', '').gsub('University of', '').gsub('()', '').strip<=>y.name.gsub('The University of', '').gsub('University of', '').gsub('()', '').strip}
    results = {}
    groups.each do |group|
      records = @records.select { |record| record.church == group }
      results[group.name.gsub('The University of', '').gsub('University of', '').gsub('()', '').strip] = prepare_totals(records)
    end
    results
  end

  def total_for_campuses
    groups = @records.map(&:church).uniq.select{ |church| !church.sunday_meeting }.sort{|x, y| x.name.gsub('The University of', '').gsub('University of', '').gsub('()', '').strip<=>y.name.gsub('The University of', '').gsub('University of', '').gsub('()', '').strip}
    results = {}
    groups.each do |group|
      records = @records.select { |record| record.church == group }
      results[group.name.gsub('The University of', '').gsub('University of', '').gsub('()', '').strip] = prepare_totals(records)
    end
    results
  end

  def total_for_region
    groups = @records.map(&:church).uniq.map(&:church_group).uniq.map(&:region).uniq.sort
    results = {}
    groups.each do |group|
      records = @records.select { |record| record.church.church_group.region == group }
      results[group] = prepare_totals(records)
    end
    results
  end

  def total_for_city
    cities = @records.map(&:church).uniq.map(&:city).uniq.sort
    results = {}
    cities.each do |city|
      records = @records.select { |record| record.church.city == city }
      results[city] = prepare_totals(records)
    end
    results
  end

  def get_workers
    @results[:people] = @records.map(&:church).uniq.map {|church| { name: church.elder.name, church: church.name, email: church.elder.email } }
  end

  private

  def averages(records=@records, start_month, end_month)
    sums = totals(records, start_month, end_month)
    sums.each { |key, value| sums[key] = (value / sums[:n]).round(0) }
    sums
  end

  def totals(records=@records, start_month, end_month)
    attrs = [:sunday_att, :first_timers, :new_converts, :nbs, :nbs_finish, :baptised, :fnb]
    attrs_names = ["sunday", "ft", "newConv", "nbs", "fnbs", "bap", "tithe"]
    results = {}
    d1 = Date.parse(start_month)
    d2 = Date.parse(end_month)
    divisor = d1.next_year == d2 ? 12.0 : 1.0
    title = d1.next_year == d2 ? "Last 12 months": start_month
    results = { month: title }
    recs = records.select{ |record| (d1..d2-1).include?(record.day) }
    attrs.each_with_index { |attribute, index| results[attrs_names[index]] = ( ( recs.map{ |rec| rec[attribute] || 0 }.inject(&:+) || 0 ) / divisor).round(0).to_s }
    results[:n] = recs.map(&:day).uniq.count.to_f.to_s
    if results[:n].to_i != 0 
      results["sunday"] = (results["sunday"].to_f * divisor / results[:n].to_f).round(0).to_s
    end
    results
  end

  def prepare_info
    result = {
      "Date Started"=> "2013",
      "Past Year Average Weekly Attendance"=> @results[:totals]["Last 12 months"]["sunday"],
      "Branches"=> Church.where(sunday_meeting: true).count.to_s,
      "London Campuses"=> Church.where(city: "London CC").count.to_s,
      "Pastors"=> User.where(role: "Pastor").count.to_s,
      "Elders"=> User.where(role: "Elder").count.to_s,
      "Church Planters"=> User.where(role: "Church Planter").count.to_s,
      "Church Groups"=> ChurchGroup.count.to_s,
      "Total Campus Churches"=> Church.count.to_s
    }
  end

  def authorised
    valid_token || (current_user && current_user.admin)
  end

  def valid_token
    !!params[:mobile] && !!MobileToken.find_by_auth_token(params[:mobile])
  end

  def check_access
    redirect_to unauthorised_path unless authorised
  end


end