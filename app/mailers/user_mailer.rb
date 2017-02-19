class UserMailer < ApplicationMailer
  def password_reset(user)
    @user = user
    mail to: @user.email, subject: "Welcome to Revelations"
  end

  def welcome_email(user)
    @user = user
    mail to: ENV["TEST_MAIL"], subject: "Welcome To Revelations!"
  end

end
