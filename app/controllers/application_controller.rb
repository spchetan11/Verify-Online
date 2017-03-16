class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  include SessionsHelper
  # rescue_from ActiveRecord::RecordNotFound, with: :error 
  # rescue_from Exception, with: :error
  rescue_from ActionController::RoutingError, with: :not_found

def raise_not_found
  raise ActionController::RoutingError.new("No route matches #{params[:unmatched_route]}")
end

def not_found
  respond_to do |format|
    format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
    format.xml { head :not_found }
    format.any { head :not_found }
  end
end

def error
  respond_to do |format|
    format.html { render :file => "#{Rails.root}/public/500", :layout => false, :status => :error }
    format.xml { head :not_found }
    format.any { head :not_found }
  end
end



  
    private
    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def has_access
      logged_in? || admin_user_signed_in?
    end
    
  
end
