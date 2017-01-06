class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
   include SessionsHelper
   include ApplicationHelper

   helper_method :month
   
  def month(offset, format='long')
    format == 'short' ? (Date.today << offset).strftime('%b-%y') : (Date.today << offset).strftime('%b%Y')
  end

  def date_of_last(day)
  date  = Date.parse(day)
  delta = date > Date.today ? -7 : 0
  date + delta
end

def date_of_next(day)
  date  = Date.parse(day)
  delta = date > Date.today ? 0 : 7
  date + delta
end

  def sun_in_month(month)
  a= Date.parse(month)..((Date.parse(month)>>1))-1
  b= a.select{|x| x.wday==0}
  b
  end



end
