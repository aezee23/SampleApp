class User < ActiveRecord::Base
	belongs_to :church_group
	has_many :records
	before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password

Excerpt From: Michael Hartl. “Ruby on Rails Tutorial.” iBooks. https://itun.es/gb/6AW96.l
end
