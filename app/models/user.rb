class User < ActiveRecord::Base
	belongs_to :church_group
	has_many :records
  attr_accessor :remember_token, :activation_token, :reset_token
	before_save { self.email = email.downcase }
validates :name, presence: true, length: { maximum: 50 }
VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
has_secure_password
validates :password, presence: true, length: { minimum: 6 }, confirmation: true, :unless => :already_has_password?
validates_inclusion_of :is_leader, in: [true, false]


def ytd_visitation
  n = Date.today.cwyear == 2016 ? Date.today.cweek - Date.parse("26Mar2016").cweek : Date.today.cweek
  visitation_count = self.records.where("day >= ?", Date.parse("26Mar2016")).where(visitation: true).count
  (visitation_count.to_f / n * 100).to_i
end

def ytd_avg(y)
  n = self.records.where(day: ((Date.parse(Date.today.strftime("%Y0101"))..Date.today))).count
  if n ==0
    0
  else
  a = self.records.where(day: ((Date.parse(Date.today.strftime("%Y0101"))..Date.today))).pluck(y).first(n)
  sum_a = a.inject(0){|sum,x| sum + x }
  avg= sum_a/n.to_f
  avg.round(0)
end
end

def qtd_avg(y)
  n = self.records.where(day: ((Date.today << 3)..Date.today)).count
  if n ==0
    0
  else
  a = self.records.where(day: ((Date.today << 3)..Date.today)).pluck(y).first(n)
  sum_a = a.inject(0){|sum,x| sum + x }
  avg= sum_a/n.to_f
  avg.round(0)
end
end

def month_avg(month, att)
   n = self.records.where(day: (Date.parse(month)..(Date.parse(month)>>1)-1)).count
if n == 0
    0
  else
  a = self.records.where(day: (Date.parse(month)..(Date.parse(month)>>1)-1)).pluck(att).first(n)
  sum_a = a.inject(0){|sum,x| sum + x }
  avg= sum_a/n.to_f
  avg.round(0)
end
end

def make_hash_monthly_avg(att)
  a = {}
  b= (Date.parse((Date.today<<12).strftime("%b%Y%"))..Date.parse(Date.today.strftime("%b%Y")))
  c= b.map{|x| x.strftime("%b%Y")}.uniq
  c.each do |t|
    a[t]= self.month_avg(t, att) || 0
  end 
  a
end


def make_hash_monthly_sum(att)
  a = {}
  b= (Date.parse((Date.today<<12).strftime("%b%Y%"))..Date.parse(Date.today.strftime("%b%Y")))
  c= b.map{|x| x.strftime("%b%Y")}.uniq
  c.each do |t|
    a[t]= self.month_sum(t, att) || 0
  end 
  a
end

def make_hash_time_series(func)
  a = self.records.order('day ASC').pluck(:day)
  b = {}
  a.each do |x|
    b["#{x}"]= self.records.find_by(day: x)[func]
  end
  b
end

def ytd_sum(att)
 n = self.records.where(day: ((Date.parse(Date.today.strftime("%Y0101"))..Date.today))).sum(att)
end

def qtd_sum(att)
n = self.records.where(day: (((Date.today) << 3)..(Date.today))).sum(att)
end

def month_sum(month, att)
 n = self.records.where(day: (Date.parse(month)..(Date.parse(month) >> 1)-1)).sum(att)
end

def day_attr(x, att)
  if self.records.find_by(day: x).nil?
    0
  else
 n = self.records.find_by(day: x)[att]||0
end
end




def latest(x)
  a = self.records.find_by(day: date_of_last("Sunday"))
  if a.nil?
    0
  else
    a[x]
  end
end



def self.make_hash_latest(func)
b = {}
c= User.order('city ASC').where.not(admin: true).uniq.pluck(:city)
c.each do |f|
d= self.where(city: f).map {|y| y.latest(func)}
e= d.inject(0) {|sum, y| sum + y}
b["#{f}"] = e
  end
b
end

def missing_data
  if self.records.where('day > ?', Date.parse(Date.today.strftime('%Y0101'))).count < (Date.today+1).cweek
    "Missing #{(Date.today+1).cweek-self.records.where('day > ?', Date.parse(Date.today.strftime('%Y0101'))).count} #{"Record".pluralize((Date.today+1).cweek-self.records.count)}"
  else
    "Complete"
  end
end


def has_not_submitted
self.records.find_by(day: date_of_last("Sunday")).nil?
end

  def date_of_last(day)
  date  = Date.parse(day)
  delta = date > Date.today ? -7 : 0
  date + delta
end

def self.search(query)
  where("name ILIKE ? OR elder ILIKE ?", "%#{query}%", "%#{query}%") 
end
# Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.weeks.ago
  end

   private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

    def already_has_password?
      !self.password_digest.blank?
    end


end
