class EldersController < ApplicationController
  def index
  	@elder = []
  	 User.where(admin: false).each do |x|
  	 	@elder.push(x.elder)
  	 end
  end
end
