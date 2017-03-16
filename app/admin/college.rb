ActiveAdmin.register College do
menu priority: 4
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :user_id, :name, :email, :phone, :address, :logo, :verification_amount
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end
	index :title => "Colleges" do |college|
		selectable_column

		column "Sl. no.", :id
		column "Name", :name

		column "Email", :email
		column "Phone", :phone
		column "Address", :address
		column "Verification Amount", :verification_amount


		column "Report Template" do |college|
		   raw "<a href='/report_data?college_id=#{college.id}' target='blank'>Edit</a>"
		end

		# column "College" do |verification_request|
		#    link_to verification_request.college.name, admin_college_path(verification_request.college)
		# end

		# column "Status" do |verification_request|
		#    verification_request.verification_status.description
		# end

		# column "Request Date" do |verification_request|
		# 		if verification_request.verification_status_id > 2
		# 			raw "#{local_time(verification_request.created_at + 330.minutes, '%d/%m/%Y %l:%M%p')}"
		# 		end
		# end

		# column "Last updated" do |verification_request|
		# 		if verification_request.verification_status_id > 2
		# 			raw "#{local_time(verification_request.updated_at + 330.minutes, '%d/%m/%Y %l:%M%p')}"
		# 		end
		# end

		# column "Report" do |verification_request|
		# 	show_link = false
		# 	if !verification_request.college.report_datum.nil? 
		# 		if !verification_request.college.report_datum.header_file_name.nil? && 
		# 			!verification_request.college.report_datum.signature_file_name.nil? 
	 #   				show_link = true 
	 #   			end
	 #   		end
	 #   		if verification_request.verification_status_id > 2
		# 	   	if show_link == true 
		# 	   		raw "<a href='/final_report_user.pdf?verification_id=#{verification_request.id}' target='blank'>download</a>"
		# 	   	else
		# 	   		"Report format unavailable"
		# 	   	end
		# 	end
		# end
		         
		actions
	end


end
