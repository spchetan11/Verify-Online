cuser=User.create!(
	name:  'John',
	email: "john@example.com",
	phone: 8050236035,
	address:   FFaker::Address.street_address,
	city: 	FFaker::Address.city ,
	pincode: 	560006,
	state: 	"Karnataka",
	country: 	"India",
	password:              "password",
	password_confirmation: "password",
	activated:    true,
	activated_at: Time.zone.now
)
College.create!(
	user_id: cuser.id,
	name: "Siddartha Test College", 
	email: "siddartha_college@example.com",
	phone: FFaker::PhoneNumber.short_phone_number,
	address: "Hyderabad",
	verification_amount: 800
)
# ReportDatum.create!(
# 	college_id: 1, 
# 	# header_link: FFaker::Avatar.image, 
# 	# signature_link: FFaker::Avatar.image, 
# 	from_address: FFaker::Address.street_address, 
# 	to_address: "_USER_TO_ADDRESS_", 
# 	letter_title: FFaker::Lorem.sentence, 
# 	subject: FFaker::Lorem.sentence, 
# 	body: "#{FFaker::Lorem.paragraph} _STATUS_ #{FFaker::Lorem.paragraph}",
# 	designation: FFaker::Job.title
# )

# User.create!(
# 	name:  'allen',
# 	email: "allen@gmail.com",
# 	phone: 8553047951,
# 	address:   FFaker::Address.street_address,
# 	city: 	FFaker::Address.city ,
# 	pincode: 	560006,
# 	state: 	"Karnataka",
# 	country: 	"India",
# 	password:              "password",
# 	password_confirmation: "password",
# 	activated:    true,
# 	activated_at: Time.zone.now
# 	)
VerificationStatus.create!(	description: "Pending"	)
VerificationStatus.create!(	description: "Insuff"	)
VerificationStatus.create!(	description: "Genuine"	)
VerificationStatus.create!(	description: "Fake")


# 15.times do |n|
# 	name = FFaker::Name.name
# 	email = FFaker::Internet.safe_email
# 	phone = FFaker::PhoneNumber.short_phone_number
# 	address = FFaker::Address.street_address
# 	city = FFaker::Address.city 
# 	state = "Karnataka"
# 	password = "password"
	
# 	User.create!(name:  name,
# 	             email: email,
# 	             phone: phone,
# 	             address: address,
# 				 city: city,
# 				 pincode: 	560006,
# 				 state: 	"karnataka",
# 				 country: 	"India",
# 	             password:              password,
# 	             password_confirmation: password,
# 	             activated:    true,
# 	             activated_at: Time.zone.now)
# end


# i = 0
# 30.times do |n|
# 	i = i + 1
# 	name = FFaker::Company.name
# 	address = FFaker::Address.street_address
# 	email = FFaker::Internet.safe_email
# 	phone = FFaker::PhoneNumber.short_phone_number
# 	amount = rand(500..2000)
# 	college = College.create!(name: name, email: email, phone: phone, address: address,verification_amount: amount)

# 	# ReportDatum.create!(
# 	# 	college_id: college.id, 
# 	# 	from_address: FFaker::Address.street_address, 
# 	# 	to_address: "_USER_TO_ADDRESS_", 
# 	# 	letter_title: FFaker::Lorem.sentence, 
# 	# 	subject: FFaker::Lorem.sentence, 
# 	# 	body: "#{FFaker::Lorem.paragraph} _STATUS_ #{FFaker::Lorem.paragraph}",
# 	# 	designation: FFaker::Job.title
# 	# )
# end

# 30.times do |n|
# 	hallticket_no = FFaker::Lorem.characters(10)	
# 	Student.create!(hallticket_no: hallticket_no)
# end


1.times do |n|
	user_id = cuser.id
	college_id = 1
	verification_status_id = 1
	name = name = FFaker::Name.name
	hallticket_no = FFaker::Lorem.characters(6)	
	document_link = "https://s3-ap-southeast-1.amazonaws.com/verifyonline-documents/uploads/dummy/wo.jpg"	
	amount = rand(500..2000)
	service_tax = amount * 0.05
	# course = FFaker::Lorem.characters(5).upcase
	# type_of_studies = 	FFaker::Lorem.characters(3).upcase

	VerificationRequest.create!(user_id: user_id,
		college_id: college_id,
		verification_status_id: verification_status_id,
		name: name,
		hallticket_no: hallticket_no,
		document_link: document_link,
		amount: amount,
		service_tax: service_tax #,
		# course: course,
		# type_of_studies: type_of_studies
		)
end


AdminUser.create!(email: 'admin@verifyonline.in', password: 'VerifyOnline@_123', password_confirmation: 'VerifyOnline@_123')