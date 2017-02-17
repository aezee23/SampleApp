class Record < ActiveRecord::Base
	belongs_to :user
  belongs_to :church

default_scope -> { order(day: :desc) }
validates :user_id, presence: true
validates :church_id, presence: true
validates :day, presence: true, uniqueness: {scope: :church_id, message: "already has data recorded for it. Check date."}
validates :sunday_att, presence: true, numericality: { less_than_or_equal_to: 999,  only_integer: true }
validates :weekday_att, presence: true, numericality: { less_than_or_equal_to: 999,  only_integer: true }
validates :first_timers, presence: true 
validate :ft_const
validate :right_day
validate :future_day
validates :new_converts, presence: true
validates :nbs, presence: true
validates :fnb, presence: true
validates :message_sunday, presence: true
validates :message_weekday, presence: true
validates :preacher_sunday, presence: true
validates :preacher_weekday, presence: true
validates :baptised, presence: true


def +(record)
  return nil unless self.day == record.day
  Record.new(
      day: self.day,
      sunday_att: (self.sunday_att || 0) + (record.sunday_att || 0),
      weekday_att: (self.weekday_att || 0) + (record.weekday_att || 0),
      first_timers: (self.first_timers || 0) + (record.first_timers || 0),
      new_converts: (self.new_converts || 0) + (record.new_converts || 0),
      baptised: (self.baptised || 0) + (record.baptised || 0),
      nbs: (self.nbs || 0) + (record.nbs || 0),
      nbs_finish: (self.nbs_finish || 0) + (record.nbs_finish || 0),
      fnb: (self.fnb || 0) + (record.fnb || 0)
    )
end

  def ft_const
    if self.sunday_att && (self.first_timers > self.sunday_att)
      self.errors.add :base, "First Timers cannot be greater than Total attendance"
    end
  end

  def right_day
  	if !self.day.sunday?
  		self.errors.add :base, "Date entered must be a Sunday!!!"
  	end
  end

  def future_day
  	if self.day > Date.today
  		self.errors.add :base, "Date cannot be in the future!"
  	end
  end

  def self.search(search)
    if search
      Record.where("preacher_weekday ILIKE ?", "%#{search}%") 
    else
      Record.all
    end
  end

  def self.total_month_avg(r, attribute, month)
    r.select{ |record| record.user.sunday_meeting }
        .select{ |record| (Date.parse(month)..(Date.parse(month)>>1)-1).include?(record.day) }
        .map(&attribute).inject(&:+)
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |record|
        csv << record.attributes.values_at(*column_names).insert(-1, record.user.name)
      end
    end
  end

end
