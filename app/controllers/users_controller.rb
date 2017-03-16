class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy ]
  before_action :correct_user,   only: [:edit, :update, :show]
  before_action :admin_user,     only: :destroy

  # GET /users
  # GET /users.json
  def index
    @users = User.all


  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)  
    if @user.save
      # Send activation link as email (and SMS)
      # url = HTTParty.get("#{ENV['MVAAYOO_URL']}?user=#{ENV['MVAAYOO_USER']}:#{ENV['MVAAYOO_PASSWORD']}&senderID=TEST%20SMS&receipientno=#{@user.phone}&msgtxt=New verification for #{@college_ver.name}. Name: #{@verification_request.name}. Hallticket: #{@verification_request.hallticket_no}&state=4")
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to login_url
    else
      render 'new'
    end

  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update   
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to  :action => 'edit'
    else
      render 'edit'
    end 
  
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email,:phone, :password, :password_confirmation, :address, :city, :pincode, :state, :country)
    end

       # Before filters
    
    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
