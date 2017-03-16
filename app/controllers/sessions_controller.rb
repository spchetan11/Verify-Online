class SessionsController < ApplicationController
  def new
  end

  def create
  	
  	user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      if user.activated?  
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        # redirect_back_or user
        if is_college_admin?  
          redirect_back_or view_verifications_path
        else
          redirect_back_or apply_path 
        end
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end

  end

  def destroy
  	log_out if logged_in?
    redirect_to root_url
  end
end