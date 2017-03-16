class ContactMailer < ActionMailer::Base

	def contact_created(name,email,message)
    @name = name
	@email = email
	@message = message
    address = Mail::Address.new "support@veryfyonline.in"
    address.display_name = "VerifyOnline.in Support"
    mail from: address.format, to: email, subject: "Thank you for cantacting Verify Online"
  end
end 