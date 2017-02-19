class Member < ActiveRecord::Base
  belongs_to :church
  belongs_to :church_group
  mount_uploader :avatar, AvatarUploader

  before_save { self.email = email.downcase if self.email }
  validates :name, presence: true, length: { maximum: 50 }
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  def pastor
    self.church_group.leader
  end
  
  def small_thumbnail(size = 50)
    gravatar_id = Digest::MD5::hexdigest(self.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    self.avatar? ? self.avatar.small_thumb.url : gravatar_url
  end

end
