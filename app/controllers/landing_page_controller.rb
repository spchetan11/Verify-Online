class LandingPageController < ApplicationController
 	before_action :set_colleges, only:[:index,:search_page]


  def index
  
  end
  
  def search_page
  	
  end

  def verification_status
  	@status = VerificationRequest.where("verification_token ILIKE ?", params[:id])

  	respond_to do |format|
      format.json {render json: @status}
    end
  end

  def contact_create
    ContactMailer.contact_created(params[:name],params[:email],params[:message]).deliver_now
    redirect_to root_path, notice: 'Thanks for contacting us. We will get back to you shortly.' 
  end


  private

  def set_colleges
  	@all_colleges = College.all.select(:id, :name, :email, :phone, :address, :verification_amount)
  end
end
