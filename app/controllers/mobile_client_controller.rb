class MobileClientController < ApplicationController
  before_action :check_access, except: [:unauthorised]

  def summary
    @results = {}
    prepare_summary
    render json: @results
  end

  def unauthorised
    render json: "Access denied"
  end


  def prepare_summary
    @records ||= Record.includes( user: [:church_group] ).where(
      day: (Date.today.last_year.beginning_of_year..Date.today)
      )
    @results[:totals] = prepare_totals(@records.select{ |record| record.user.sunday_meeting })
    @results[:totals_by_group] = total_for_church_group
    @results[:totals_by_city] = total_for_city
  end

  def prepare_totals(records)
    months = (Date.today.last_year..Date.today).map{|day| day.strftime("%b%Y")}.uniq.reverse
    results = {}
    results["Last 12 months"] = totals(records, months[12], months[0])
    months.each do |month|
      next_month = (Date.parse(month) >> 1).strftime("%b%Y")
      results[month] = totals(records, month, next_month)
    end

    results
  end

  def total_for_church_group
    groups = @records.map(&:user).uniq.map(&:church_group).uniq.map(&:name).uniq
    results = {}
    groups.each do |group|
      records = @records.select { |record| record.user.church_group.name == group }
      results[group] = prepare_totals(records)
    end
    results
  end

  def total_for_city
    cities = @records.map(&:user).uniq.map(&:city).uniq
    results = {}
    cities.each do |city|
      records = @records.select { |record| record.user.city == city }
      results[city] = prepare_totals(records)
    end
    results
  end

  def get_workers
    @results[:people] = @records.map(&:user).uniq.map {|user| { name: user.elder, church: user.name, email: user.email } }
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
    title = start_month
    results = { month: title }
    recs = records.select{ |record| (d1..d2-1).include?(record.day) }
    attrs.each_with_index { |attribute, index| results[attrs_names[index]] = ( ( recs.map{ |rec| rec[attribute] || 0 }.inject(&:+) || 0 ) / divisor).round(0).to_s }
    results[:n] = recs.map(&:day).uniq.count.to_f.to_s
    if results[:n].to_i != 0 
      results["sunday"] = (results["sunday"].to_f * divisor / results[:n].to_f).round(0).to_s
    end
    results
  end

  def authorised
    !!params[:mobile] && !!MobileToken.find_by_auth_token(params[:mobile])
  end

  def check_access
    redirect_to unauthorised_path unless authorised
  end


end