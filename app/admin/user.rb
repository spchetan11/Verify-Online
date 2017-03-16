ActiveAdmin.register User do
menu priority: 3
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :name, :email,:phone, :password, :password_confirmation, :address, :city, :pincode, :state, :country
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end
	index :title => "Users" do |user|
		selectable_column

		column "ID", :id
		column "Name", :name
		column "Email", :email
		column "Phone", :phone
		column "Address", :address
		column "City", :city
		column "Pincode", :pincode
		column "State", :state
		column "Country", :country
		column "Activated?", :activated
		# column "Activated On" do |user|
		# 	raw "#{local_time(user.activated_at + 330.minutes, '%d/%m/%Y %l:%M%p')}"
		# end
	end

	show do    
		attributes_table  do
			row :id
			row :name
			row :email
			row :phone
			row :address
			row :city
			row :pincode
			row :state
			row :country
			row :activated
		end	   
	end

	form do |f|
	    f.inputs "User Details" do
			f.input :name
			f.input :email
			f.input :password
			f.input :password_confirmation
			f.input :phone
			f.input :address
			f.input :city
			f.input :pincode
			f.input :state
			f.input :country
	    end
	    f.actions
  	end

end
