class ChurchGroup < ActiveRecord::Base
	belongs_to :user
  has_many :churches
  has_many :members
	has_many :records, through: :churches
  validates :user_id, presence: true
	validates :name, presence: true, uniqueness: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  def leader
    self.user
  end

  def combined_records
    self.records.group_by(&:day).
      map{ |date, record_array| record_array.reduce(&:+) }
  end

  def latest(h)
    record = combined_records.select{ |record| record.day == date_of_last_sunday }[0]
    record ? record[h] : 0
  end

  def date_of_last_sunday
    date  = Date.parse("Sunday")
    delta = date > Date.today ? -7 : 0
    date + delta
  end

end