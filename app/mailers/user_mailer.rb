class UserMailer < ApplicationMailer
  def password_reset(user)
    @user = user
    mail to: @user.email, subject: "Welcome to Revelations"
  end

  def welcome_email(user)
    @user = user
    mail to: user.email, subject: "Welcome To Revelations!"
  end

  def missed_email(church)
    @church = church
    @user = church.elder
    @leader = church.church_group.leader
    mail to: "#{@leader.email}; #{@user.email if @user != @leader}", bcc: "aezee23@aol.com", from: "data-office@flcrevelations.co.uk", subject: "Missed Deadline"
  end

  def project_email(user)
    @user = user
    mail to: user.email, subject: "Members Visitation Project"
  end

end
