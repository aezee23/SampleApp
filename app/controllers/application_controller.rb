class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
   include SessionsHelper

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



end
