class Record < ActiveRecord::Base
	belongs_to :user
default_scope -> { order(day: :desc) }
validates :user_id, presence: true
validates :day, presence: true, uniqueness: {scope: :user_id}
validates :sunday_att, presence: true, numericality: { less_than_or_equal_to: 999,  only_integer: true }
validates :weekday_att, presence: true, numericality: { less_than_or_equal_to: 999,  only_integer: true }
validates :first_timers, presence: true 
validate :ft_const
validates :new_converts, presence: true
validates :nbs, presence: true
validates :fnb, presence: true


def ft_const
  if self.sunday_att &&(self.first_timers> self.sunday_att)
    self.errors.add_to_base("First Timers cannot be greater than Total attendance")
  end
end
end
