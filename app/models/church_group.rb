class ChurchGroup < ActiveRecord::Base
	has_many :users
	has_many :records, through: :users
	validates :name, presence: true, uniqueness: true



def sum_ytd_avg(h)
a =	self.users.map {|x| x.ytd_avg(h)}
 sum_a = a.inject(0){|sum,x| sum + x }
end

def sum_latest(h)
a =	self.users.map {|x| x.latest(h)}
b = a.inject(0){|sum,x| sum + x }
end

end
