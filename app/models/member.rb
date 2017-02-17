class Member < ActiveRecord::Base
  belongs_to :church
  belongs_to :church_group
  mount_uploader :avatar, AvatarUploader
end
