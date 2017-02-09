class Church < ActiveRecord::Base
  has_many :records
  belongs_to :church_group
  belongs_to :elder, class_name: User, foreign_key: :user_id

  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 60 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates_inclusion_of :sunday_meeting, in: [true, false]
  validates :city, presence: true


  def missing_data
    if self.records.where('day > ?', Date.parse(Date.today.strftime('%Y0101'))).count < (Date.today+1).cweek
      "Missing #{(Date.today+1).cweek-self.records.where('day > ?', Date.parse(Date.today.strftime('%Y0101'))).count} #{"Record".pluralize((Date.today+1).cweek-self.records.count)}"
    else
      "Complete"
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

  def missing_data?
    missing_data.count > 0
  end

  def missing_data
    date = [Date.today << 12, self.date_started || self.created_at ].max
    start = date
    end_date = Date.today
    sundays = (start.to_date..end_date.to_date).select{ |day| day.wday == 0 }
    records = self.records.where(day: (start..end_date))
    sundays.select do |date|
      records.select { |rec| rec.day == date }.count == 0
    end
  end

  def data_status
    n = missing_data.count
  end


  private

  def sweek(date)
    date.cweek
  end

  def date_of_last(day)
    date  = Date.parse(day)
    delta = date > Date.today ? -7 : 0
    date + delta
  end

end