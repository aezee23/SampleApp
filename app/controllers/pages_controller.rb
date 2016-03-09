class PagesController < ApplicationController
	def index
		@date = date_of_last("Sunday").strftime('%d%b%y')
		@users = []
		User.where(admin: false).each do |t|
			if t.has_not_submitted
				@users << t
			end
		end

	end

end
