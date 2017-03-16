ActiveAdmin.register Payment do
menu priority: 2
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
actions :index

	index :title => "Payments" do |payment|
		selectable_column

		column "Sl. no.", :id
		column "Buyer", :buyer
		column "Buyer Name", :buyer_name
		column "Amount", :amount
		column "Fees", :fees
		column "MAC Address", :mac
		column "Offer Title", :offer_title
		column "Phone", :buyer_phone
		column "Currency", :currency
		column "Status", :status
	end

end
