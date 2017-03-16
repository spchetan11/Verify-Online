class CollegeVerificationController < ApplicationController
	 before_action :set_college_id, :except => [:report]
   layout 'application', :except => [:report]

  def index
  	if params.has_key?(:search_tag)
      @college_verifications =  VerificationRequest.all.where(
        " payment_id IS NOT null AND 
          college_id = ? AND 
          verification_status_id <= ? AND 
          (
            hallticket_no ILIKE ? OR 
            name ILIKE ? OR verification_token ILIKE ?
            )
        ", 
          
        @college_id, 
        2, 
        "%#{params[:search_tag]}%",
        "%#{params[:search_tag]}%",
        "%#{params[:search_tag]}%"
        
        ).order('created_at DESC').
        paginate(page: params[:page],:per_page => 10)
    else  
  	  @college_verifications =  VerificationRequest.all.where(
        " payment_id IS NOT null AND 
          college_id = ? AND verification_status_id <= ?", 
          @college_id, 
          2
        ).order('created_at DESC')
      .paginate(page: params[:page],:per_page => 10)
    end
  end


  def completed
    if params.has_key?(:search_tag)
      @college_verifications_completed =  VerificationRequest.all.where(
        " payment_id IS NOT null AND college_id = ? AND verification_status_id > ? AND (hallticket_no ILIKE ? OR name ILIKE ? OR verification_token ILIKE ?)", 
          @college_id, 
          2, 
          "%#{params[:search_tag]}%",
          "%#{params[:search_tag]}%",
          "%#{params[:search_tag]}%"
        ).order('created_at DESC')
      .paginate(page: params[:page],:per_page => 10)
    else  
      @college_verifications_completed =  VerificationRequest.all.where(
        " payment_id IS NOT null AND college_id = ? AND verification_status_id > ?", 
          @college_id, 
          2
        ).order('created_at DESC')
      .paginate(page: params[:page],:per_page => 10)
    end
  end

  def report
    @disable_header_footer = true
    @verification_stub = VerificationRequest.find_by(id: params[:verification_id])
    @college = current_user.college
    @user = User.find_by(id: @verification_stub.user_id)
    @client_ip = request.remote_ip
    respond_to do |format|
      format.pdf do
        pdf = WickedPdf.new.pdf_from_string(
          render_to_string(template: "report_data/report.html.erb"),
          :footer => {right: "powered by www.verifyonline.in"}
        ) 
        send_data(pdf, 
          :filename    => "report_#{@verification_stub.name.gsub(/\s+/, "")}_#{@verification_stub.hallticket_no}.pdf", 
          :disposition => 'attachment'
        )

        # render  pdf: "report_#{@verification_stub.name.gsub(/\s+/, "")}_#{@verification_stub.hallticket_no}", 
        #         template: "college_verification/report.html.erb"
      end
    end
  end

  def payment
    @college_verifications =  VerificationRequest.select("payment_id").where("college_id = ?", @college_id)
    @searched = false
    if params.has_key?(:search_tag)
      @payments = Payment.all.where(:id => @college_verifications).where(
        "transaction_id = ?", 
        "%#{params[:search_tag]}%"
        ).order('created_at DESC')
      .paginate(page: params[:page],:per_page => 10)
      @searched = true
    elsif params.has_key?(:fromdate) && params.has_key?(:todate)
      @fromDate = Date.parse(params[:fromdate]) rescue nil
      @toDate = Date.parse(params[:todate]) rescue nil
      if @fromDate.present? && @toDate.present?
        @payments = Payment.all.where(:id => @college_verifications).where(
          "date(created_at) BETWEEN ? AND ?", 
          "%#{params[:fromdate]}%",
          "%#{params[:todate]}%"
          ).order('created_at DESC')
        .paginate(page: params[:page],:per_page => 10)
        @searched = true
      end
    end 
  end

  def update
    @verification_request = VerificationRequest.find(params[:id])
    if @verification_request.update_attributes(update_params)
      flash[:success] = "Verification Status updated"
      redirect_to view_verifications_path
    else
       flash[:success] = "Update failed"
      redirect_to view_verifications_path
    end 
  end


  private

    def set_college_id
      @college_id = current_user.college.id      
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def update_params
      params.permit(:course, :type_of_studies,:course_duration, :class_awarded, :remarks, :verification_status_id)
    end

end
