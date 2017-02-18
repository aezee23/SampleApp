class SessionsController < ApplicationController


  def new
    redirect_to demo_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      flash[:success] = "Thank you for logging in #{user.name}"
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      if (user.is_leader? || !user.admin)
        redirect_to home_path
      else
        redirect_to demo_path
      end
    else
     flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    flash[:info] = "You successfully logged out."
    redirect_to login_url
  end

end
