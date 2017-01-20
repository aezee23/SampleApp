class VisitationRecord < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(day: :desc) }
  validates :day, presence: true, uniqueness: {scope: :user_id, message: "already has data recorded for it. Check date."}
  validates_inclusion_of :visitation, in: [true, false]
end