class ChurchGroup < ActiveRecord::Base
	has_many :users
	has_many :records, through: :users
	validates :name, presence: true, uniqueness: true
end
