class ChurchGroup < ActiveRecord::Base
	has_many :users
	has_many :records, through: :users
	validates :name, presence: true, uniqueness: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }


def sum_day_attr(d, att)
a =	self.users.map {|x| x.records.find_by(day: d)[att]||0}
 sum_a = a.inject(0){|sum,x| sum + x }
end

def sum_ytd_avg(att)
a =	self.users.map {|x| x.ytd_avg(att)||0}
 sum_a = a.inject(0){|sum,x| sum + x }
end

def sum_ytd_avg_pm(att)
a =	self.users.map {|x| x.ytd_sum(att)||0}
 sum_a = a.inject(0){|sum,x| sum + x }
 sum_a/(Date.today.month)
end

def sum_qtd_avg(att)
a =	self.users.map {|x| x.qtd_avg(att)||0}
 sum_a = a.inject(0){|sum,x| sum + x }
end

def sum_month_avg(month, att)
a =	self.users.map {|x| x.month_avg(month, att)||0}
 sum_a = a.inject(0){|sum,x| sum + x }
end

def sum_day_attr(y, att)
a =	self.users.map {|x| x.day_attr(y, att)||0}
 sum_a = a.inject(0){|sum,x| sum + x }
end

def sum_ytd_sum(att)
a =	self.users.map {|x| x.ytd_sum(att)||0}
 sum_a = a.inject(0){|sum,x| sum + x }
end

def sum_qtd_sum(att)
a =	self.users.map {|x| x.qtd_sum(att)||0}
 sum_a = a.inject(0){|sum,x| sum + x }
end

def sum_month_sum(month, att)
a =	self.users.map {|x| x.month_sum(month, att)||0}
 sum_a = a.inject(0){|sum,x| sum + x }
end

def sum_latest(h)
a =	self.users.map {|x| x.latest(h)||0}
b = a.inject(0){|sum,x| sum + x }
end

def make_hash_monthly_avg(att)
  a = {}
  b= (Date.parse((Date.today<<12).strftime("%b%Y%"))..Date.parse(Date.today.strftime("%b%Y")))
  c= b.map{|x| x.strftime("%b%Y")}.uniq
  c.each do |t|
    a[t]= self.sum_month_avg(t, att) || 0
  end 
  a
end
def make_hash_monthly_sum(att)
  a = {}
  b= (Date.parse((Date.today<<12).strftime("%b%Y%"))..Date.parse(Date.today.strftime("%b%Y")))
  c= b.map{|x| x.strftime("%b%Y")}.uniq
  c.each do |t|
    a[t]= self.sum_month_sum(t, att) || 0
  end 
  a
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

def self.make_hash_day_attr(func, fun)
b = {}
self.where.not(id: 1).each do |x| 
b["#{x.name}- #{x.leader.split[0]}"] = x.sum_day_attr(func, fun)
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
b["#{x.name}- #{x.leader.split[0]}"] = x.sum_latest(func)
	end
b
end

def make_hash_time_series(func)
	a = User.first.records.order('day ASC').pluck(:day)
	b = {}
	a.each do |x|
		b["#{x}"]= sum_day_attr(x, func)
	end
	b
end

def self.make_hash_time_series(func)
	a = User.first.records.order('day ASC').pluck(:day)
	b = {}
	a.each do |x|
		b["#{x}"]= self.total_day_attr(x, func)
	end
	b
end

def self.total_latest(func)
a=	ChurchGroup.where('region = ? OR region = ?', "London Main", "Judea").make_hash_latest(func)
d= a.values.inject(0) {|b, c| b+c}
d	
end

def self.total_latest_cc(func)
a=	ChurchGroup.where('region = ? OR region = ?', "London", "Judea").make_hash_latest(func)
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

def self.total_ytd_cc(func)
a=	ChurchGroup.where('region = ? OR region = ?', "London", "Judea").make_hash_ytd_sum(func)
d= a.values.inject(0) {|b, c| b+c}
d	
end

def self.total_month(month, func)
a=	ChurchGroup.where('region = ? OR region = ?', "London Main", "Judea").make_hash_month_sum(month, func)
d= a.values.inject(0) {|b, c| b+c}
d	
end

def self.total_day_attr(x, func)
a=	ChurchGroup.make_hash_day_attr(x, func)
d= a.values.inject(0) {|b, c| b+c}
d	
end

def self.total_month_cc(month, func)
a=	ChurchGroup.where('region = ? OR region = ?', "London", "Judea").make_hash_month_sum(month, func)
d= a.values.inject(0) {|b, c| b+c}
d	
end

def self.total_month_avg(month, func)
a=	ChurchGroup.where('region = ? OR region = ?', "London Main", "Judea").make_hash_month_avg(month, func)
d= a.values.inject(0) {|b, c| b+c}
d	
end

def self.total_month_avg_cc(month, func)
a=	ChurchGroup.where('region = ? OR region = ?', "London", "Judea").make_hash_month_avg(month, func)
d= a.values.inject(0) {|b, c| b+c}
d	
end

def self.judea_latest(func)
a=	ChurchGroup.where(region: "Judea").make_hash_latest(func)
d= a.values.inject(0) {|b, c| b+c}
d	
end

def self.make_total_hash_monthly_avg(att)
  a = {}
  b= (Date.parse((Date.today<<12).strftime("%b%Y%"))..Date.parse(Date.today.strftime("%b%Y")))
  c= b.map{|x| x.strftime("%b%Y")}.uniq
  c.each do |t|
    a[t]= self.total_month_avg(t, att)
  end 
  a
end

def self.make_total_hash_monthly_avg_cc(att)
  a = {}
  b= (Date.parse((Date.today<<12).strftime("%b%Y%"))..Date.parse(Date.today.strftime("%b%Y")))
  c= b.map{|x| x.strftime("%b%Y")}.uniq
  c.each do |t|
    a[t]= self.total_month_avg_cc(t, att) || 0
  end 
  a
end

def self.make_total_hash_monthly(att)
  a = {}
  b= (Date.parse((Date.today<<12).strftime("%b%Y%"))..Date.parse(Date.today.strftime("%b%Y")))
  c= b.map{|x| x.strftime("%b%Y")}.uniq
  c.each do |t|
    a[t]= self.total_month(t, att)
  end 
  a
end

def self.make_total_hash_monthly_cc(att)
  a = {}
  b= (Date.parse((Date.today<<12).strftime("%b%Y%"))..Date.parse(Date.today.strftime("%b%Y")))
  c= b.map{|x| x.strftime("%b%Y")}.uniq
  c.each do |t|
    a[t]= self.total_month_cc(t, att) || 0
  end 
  a
end

def self.make_LDN_monthly_avg_split(att)
	  a = {}
  b= (Date.parse((Date.today<<12).strftime("%b%Y%"))..Date.parse(Date.today.strftime("%b%Y")))
  c= b.map{|x| x.strftime("%b%Y")}.uniq
  c.each do |t|
    a[t]= self.where(region: "London Main").total_month_avg(t, att)== 0 ?  0 : 100*(self.where(region: "London Main").total_month_avg(t, att)-self.where(region: "London").total_month_avg_cc(t, att))/self.where(region: "London Main").total_month_avg(t, att) || 0
  end 
  a
end


end