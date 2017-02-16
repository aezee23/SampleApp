class UserMailer < ApplicationMailer
  def password_reset(user)
    @user = user
    mail to: "aezee23@aol.com", subject: "Welcome"
  end

end
