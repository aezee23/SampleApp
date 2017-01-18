class MobileToken < ActiveRecord::Base
  validates :auth_token, presence: true
  validates :name, presence: true
end