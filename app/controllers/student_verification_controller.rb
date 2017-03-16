class StudentVerificationController < ApplicationController
	include StudentVerificationHelper
	helper_method :sort_column, :sort_direction

	before_action :logged_in_user, only: [:apply, :status, :history]
	before_action :set_s3_direct_post, only: [:apply]
	skip_before_filter :verify_authenticity_token, :except => [:add_verification, :instamojo_webhook]

	require 'httparty'
	
	def apply
        if request.post?
        	puts "post request"
			redirect_to payment_path
		else
			@colleges = College.all
			if(params.has_key?(:college_id))
	        	@college_id = params[:college_id]
	        end
	        @college = College.first 
	        render 'apply'
		end
	end

	def add_verification
		@verification_request = VerificationRequest.new(verification_params)
		@college_ver = College.where(:id => @verification_request.college_id).first
		@verification_request.amount = @college_ver.verification_amount
		@verification_request.verification_status_id = 1
		@verification_request.service_tax = ENV['DEFAULT_VERF_AMOUNT'].to_f * (1 + ENV['TAX_PERCENT'].to_f / 100)

	    # respond_to do |format|
	      if @verification_request.save
	        # format.html { redirect_to @verification_request, notice: 'Student was successfully created.' }
	        url = HTTParty.get("#{ENV['MVAAYOO_URL']}?user=#{ENV['MVAAYOO_USER']}:#{ENV['MVAAYOO_PASSWORD']}&senderID=TEST%20SMS&receipientno=#{@college_ver.user.phone}&msgtxt=New verification for #{@college_ver.name}. Name: #{@verification_request.name}. Hallticket: #{@verification_request.hallticket_no}&state=4")
	        render json: @verification_request.to_json
	        # Mvaayoo.send_message "New verification for #{@college_ver.name}. Name: #{@verification_request.name}. Hallticket: #{@verification_request.hallticket_no}", @college_ver.user.phone
	        # format.json { render :show, status: :created, location: @verification_request }
	      else
	        # format.html { render :new }
	        # format.json { render json: @verification_request.errors, status: :unprocessable_entity }
	        render json: @verification_request.errors
	      end
	    # end
	end

	def report
	    @disable_header_footer = true
	    @verification_stub = VerificationRequest.find_by(id: params[:verification_id])
	    @college = College.find(@verification_stub.college_id)
	    @user = User.find_by(id: @verification_stub.user_id)
	    @client_ip = request.remote_ip
	    respond_to do |format|
	      format.pdf do
	        pdf = WickedPdf.new.pdf_from_string(
	          render_to_string(template: "report_data/report.html.erb"),
	          :footer => {right: "Powered by www.verifyonline.in"}
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

	def status
		if params.has_key?(:search_tag)
	      @verifications =  VerificationRequest.all.where(
	        " payment_id IS NOT null AND user_id = ? AND (hallticket_no ILIKE ? OR name ILIKE ? OR verification_token ILIKE ?)", 
	          current_user.id, 
	          "%#{params[:search_tag]}%",
	          "%#{params[:search_tag]}%",
	          "%#{params[:search_tag]}%"
	        ).order('created_at DESC')
	      .paginate(page: params[:page],:per_page => 10)
	    else  
	      @verifications =  VerificationRequest.all.where(
	        "payment_id IS NOT null AND user_id = ?", 
	          current_user.id
	        ).order('created_at DESC')
	      .paginate(page: params[:page],:per_page => 10)
	    end
	end

	def history
		@college_verifications =  VerificationRequest.select("payment_id").where("user_id = ?", current_user.id)
	    @searched = false
	    if params.has_key?(:search_tag)
	      @payments = Payment.all.where(:id => @college_verifications).where(
	        "transaction_id ILIKE ?", 
	        "%#{params[:search_tag]}%",
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

	def proceed_to_pay
		if(params.has_key?(:verification_ids))
			verification_ids = params["verification_ids"].split(",")
			@ver_data = VerificationRequest.all.where("id = ?", verification_ids[0]).first
			puts "Ver DATA"
			puts @ver_data.inspect
			# puts @ver_data.to_yaml

			@user = User.where("id = ?", @ver_data.user_id).first
			amount = 0
			verification_ids.map do |e|
	            ver = VerificationRequest.all.where("id = ?", e).first
	            amount += ver.amount + (ENV['DEFAULT_VERF_AMOUNT'].to_f * (1 + ENV['TAX_PERCENT'].to_f / 100))
	        end
	        amount = amount.ceil
	        puts amount
	        puts "Amount sent is ^"

			@result = HTTParty.post("https://www.instamojo.com/api/1.1/links/", 
			    :body => { 
			    	:title => "Verify Online", 
	                :description => "Hi #{@user.name}, \nProceed with payment above to complete your verification process.\n\nPlease contact support@verifyonline.in for any queries.", 
	                :currency => 'INR',
            		:quantity => 1,
            		# :buyer_name => "#{@user.name}",
            		# :email => "#{@user.email}",
            		# :phone => "#{@user.phone}",
            		# :allow_repeated_payments => false,
	                :base_price => "#{amount}", 
	                :redirect_url => "#{request.base_url}/payment_confirmation",
	                :webhook_url => "#{request.base_url}/instamojo_webhook"
	                # :webhook_url => "http://requestb.in/16bls4y1"
			    },
			    :headers => { 
			    	'X-Api-Key' => "#{ENV['INSTAMOJO_API_KEY']}",
					'X-Auth-Token' => "#{ENV['INSTAMOJO_AUTH_TOKEN']}"
				} 
			)
			puts @result.inspect
			VerificationRequest.where("id" => verification_ids).update_all(payment_slug: @result.parsed_response["link"]["slug"])
			# redirect_to @result.parsed_response["link"]["url"]
			data = JSON.parse("{\"url\":\"#{@result.parsed_response["link"]["url"]}?embed=form\"}")
			render json: data
		end
	end

	def payment_confirmation 
		@payment_id = params['payment_id']
	end

	def instamojo_webhook
	    params_data = instamojo_webhook_params
	    params_data[:transaction_id] = params_data.delete :payment_id

	    @payment = Payment.new(params_data)
		@payment.save
		VerificationRequest.where("payment_slug" => params["offer_slug"]).update_all(payment_id: @payment.id)
	end

	private

		def verification_params
	     	params.require(:verification_request).permit(:user_id, :college_id, :name, :hallticket_no, :document_link)
	    end

	    def instamojo_webhook_params
	    	# params.permit(:variants, :buyer, :custom_fields, :buyer_name, :amount, :mac, :offer_title, :fees, :offer_slug, :buyer_phone, :payment_id, :quantity, :currency, :status, :unit_price)
	    	params.permit(:payment_id, :buyer, :buyer_name, :amount, :mac, :offer_title, :fees, :buyer_phone, :currency, :status)
	    end

		def set_s3_direct_post
			@s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read')
		end


  
		def sort_column
			VerificationRequest.column_names.include?(params[:sort]) ? params[:sort] : "name"
		end

		def sort_direction
			%w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
		end

end
