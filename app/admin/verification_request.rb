ActiveAdmin.register VerificationRequest do
menu priority: 1
permit_params :user_id, :college_id, :payment_id, :name, :hallticket_no, :document_link
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end
	# controller do
	# 	def index
	# 		@verification_requests = VerificationRequest.all.where("payment_id IS NOT null AND verification_status_id <= ?", 2).order('created_at DESC')
	# 	end
	# end

	controller do
	  def scoped_collection
	    # some stuffs
	    super.where("payment_id IS NOT null")
	  end 

	  # other stuffs
	end

	csv do |verification_request|
		column ("Sl. no.") {|verification_request| verification_request.id}
		column ("Verification ID") {|verification_request| verification_request.verification_token}

		column ("Name") {|verification_request| verification_request.name}
		column ("Hallticket no") {|verification_request| verification_request.hallticket_no}
		column ("Requested on") {|verification_request| verification_request.created_at}

		column ("Document Link") do |verification_request|
		   verification_request.document_link
		end

		column ("College") do |verification_request|
		   verification_request.college.name
		end

		column ("Status") do |verification_request|
		   verification_request.verification_status.description
		end

		column ("Request Date") {|verification_request| verification_request.created_at}

		column ("Last updated") {|verification_request| verification_request.updated_at}
	end

	index :title => "Verification Requests" do |verification_request|
		selectable_column

		column "ID", :id
		column "Verification ID", :verification_token

		column "Name", :name
		column "Hallticket no", :hallticket_no
		column "Requested on", :created_at

		column "Document" do |verification_request|
		   raw "<a href='#{verification_request.document_link }' target='blank'>download</a>"
		end

		column "College" do |verification_request|
		   link_to verification_request.college.name, admin_college_path(verification_request.college)
		end

		column "Status" do |verification_request|
		   verification_request.verification_status.description
		end

		column "Request Date" do |verification_request|
				if verification_request.verification_status_id > 2
					raw "#{local_time(verification_request.created_at + 330.minutes, '%d/%m/%Y %l:%M%p')}"
				end
		end

		column "Last updated" do |verification_request|
				if verification_request.verification_status_id > 2
					raw "#{local_time(verification_request.updated_at + 330.minutes, '%d/%m/%Y %l:%M%p')}"
				end
		end

		column "Report" do |verification_request|
			show_link = false
			if !verification_request.college.report_datum.nil? 
				if !verification_request.college.report_datum.header_file_name.nil? && 
					!verification_request.college.report_datum.signature_file_name.nil? 
	   				show_link = true 
	   			end
	   		end
	   		if verification_request.verification_status_id >= 2
			   	if show_link == true 
			   		raw "<a href='/final_report_user.pdf?verification_id=#{verification_request.id}' target='blank'>download</a>"
			   	else
			   		"Report format unavailable"
			   	end
			end
		end
		         
		actions
	end

 end
