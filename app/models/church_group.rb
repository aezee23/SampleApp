class ChurchGroup < ActiveRecord::Base
	has_many :users
	has_many :records, through: :users
	validates :name, presence: true, uniqueness: true



def sum_ytd_avg(att)
a =	self.users.map {|x| x.ytd_avg(att)}
 sum_a = a.inject(0){|sum,x| sum + x }
end

def sum_ytd_avg_pm(att)
a =	self.users.map {|x| x.ytd_sum(att)}
 sum_a = a.inject(0){|sum,x| sum + x }
 sum_a/(Date.today.month)
end

def sum_qtd_avg(att)
a =	self.users.map {|x| x.qtd_avg(att)}
 sum_a = a.inject(0){|sum,x| sum + x }
end

def sum_month_avg(month, att)
a =	self.users.map {|x| x.month_avg(month, att)}
 sum_a = a.inject(0){|sum,x| sum + x }
end

def sum_ytd_sum(att)
a =	self.users.map {|x| x.ytd_sum(att)}
 sum_a = a.inject(0){|sum,x| sum + x }
end

def sum_qtd_sum(att)
a =	self.users.map {|x| x.qtd_sum(att)}
 sum_a = a.inject(0){|sum,x| sum + x }
end

def sum_month_sum(month, att)
a =	self.users.map {|x| x.month_sum(month, att)}
 sum_a = a.inject(0){|sum,x| sum + x }
end

def sum_latest(h)
a =	self.users.map {|x| x.latest(h)}
b = a.inject(0){|sum,x| sum + x }
end



def self.make_hash_ytd_avg(func)
b = {}
self.where.not(id: 1).each do |x| 
b["#{x.name}- #{x.leader.split[0]}"] = x.sum_ytd_avg(func)
	end
b
end

def self.make_hash_ytd_avg_pm(func)
b = {}
self.where.not(id: 1).each do |x| 
b["#{x.name}- #{x.leader.split[0]}"] = x.sum_ytd_avg_pm(func)
	end
b
end

def self.make_hash_qtd_avg(func)
b = {}
self.where.not(id: 1).each do |x| 
b["#{x.name}- #{x.leader.split[0]}"] = x.sum_qtd_avg(func)
	end
b
end

def self.make_hash_month_avg(func, fun)
b = {}
self.where.not(id: 1).each do |x| 
b["#{x.name}- #{x.leader.split[0]}"] = x.sum_month_avg(func, fun)
	end
b
end

def self.make_hash_ytd_sum(func)
b = {}
self.where.not(id: 1).each do |x| 
b["#{x.name}- #{x.leader.split[0]}"] = x.sum_ytd_sum(func)
	end
b
end

def self.make_hash_qtd_sum(func)
b = {}
self.where.not(id: 1).each do |x| 
b["#{x.name}- #{x.leader.split[0]}"] = x.sum_qtd_sum(func)
	end
b
end

def self.make_hash_month_sum(func, fun)
b = {}
self.where.not(id: 1).each do |x| 
b["#{x.name}- #{x.leader.split[0]}"] = x.sum_month_sum(func, fun)
	end
b
end

def self.make_hash_latest(func)
b = {}
self.where.not(id: 1).each do |x| 
b["#{x.name}- #{x.leader.split[0]}"] = x.sum_latest(func)
	end
b
end

def self.make_hash_latest_ldn(func)
b = {}
self.where(region: "London").each do |x| 
b[x.name] = x.sum_latest(func)
	end
b
end

def self.total_latest(func)
a=	ChurchGroup.where('region = ? OR region = ?', "London Main", "Judea").make_hash_latest(func)
d= a.values.inject(0) {|b, c| b+c}
d	
end

def self.total_latest_ldn(func)
a=	ChurchGroup.where(region: "London").make_hash_latest(func)
d= a.values.inject(0) {|b, c| b+c}
d	
end

def self.total_ytd_avg(func)
a=	ChurchGroup.where('region = ? OR region = ?', "London Main", "Judea").make_hash_ytd_avg(func)
d= a.values.inject(0) {|b, c| b+c}
d	
end

def self.total_ytd_avg_pm(func)
a=	ChurchGroup.where('region = ? OR region = ?', "London Main", "Judea").make_hash_ytd_avg_pm(func)
d= a.values.inject(0) {|b, c| b+c}
d	
end

def self.total_ytd(func)
a=	ChurchGroup.where('region = ? OR region = ?', "London Main", "Judea").make_hash_ytd_sum(func)
d= a.values.inject(0) {|b, c| b+c}
d	
end

def self.total_month(month, func)
a=	ChurchGroup.where('region = ? OR region = ?', "London Main", "Judea").make_hash_month_sum(month, func)
d= a.values.inject(0) {|b, c| b+c}
d	
end

def self.total_month_avg(month, func)
a=	ChurchGroup.where('region = ? OR region = ?', "London Main", "Judea").make_hash_month_avg(month, func)
d= a.values.inject(0) {|b, c| b+c}
d	
end

def self.judea_latest(func)
a=	ChurchGroup.where(region: "Judea").make_hash_latest(func)
d= a.values.inject(0) {|b, c| b+c}
d	
end




end