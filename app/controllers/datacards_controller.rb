class DatacardsController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user

def index
  @results = []
  params[:search] ? prepare_results(params[:search]) : prepare_results
  render json: @results.to_json
end

def show
  if params[:search]
    data = Datacard.new(params[:start], params[:end], params[:search]).data
  else
    data = Datacard.new(params[:start], params[:end]).data
  end
  data[:show] = true
  render json: data.to_json
end

def get_detail
  churches = Church.includes(:church_group)
  regions = churches.map(&:church_group).map(&:region).uniq.sort
  cities = churches.map(&:city).uniq.sort
  data = { cities: [],
           regions: [],
           church_groups: []
  }
  cities.each do |city|
    a = { city: city }
    a[:value] =  Datacard.new(params[:start], params[:end], "city:#{city}:attribute:#{params[:attribute]}").data[params[:attribute].to_sym]
    data[:cities] << a
  end
  regions.each do |region|
    a = { region: region }
    a[:value] =  Datacard.new(params[:start], params[:end], "region:#{region}:attribute:#{params[:attribute]}").data[params[:attribute].to_sym]
    data[:regions] << a
  end
  render json: data.to_json
end

def prepare_results(search="")
  @results << Datacard.new(date_of_last("Sunday").strftime("%d%b%Y"), (date_of_last("Sunday") + 1).strftime("%d%b%Y"), search).data
  @results << Datacard.new(last_twelve_months[-1], last_twelve_months[0], search).data
  for i in 0..3
    @results << Datacard.new(last_twelve_months[i+1], last_twelve_months[i], search).data
  end
  for i in 0..5
    @results[i][:color] = Datacard.colors[i]
  end
  for i in 0..1
    @results[i][:show] = true
  end
end

private

def last_twelve_months
  @last_twelve_months ||= (Date.today.last_year..Date.today).map{ |date| date.strftime("%b%Y") }.uniq.reverse
end


end
