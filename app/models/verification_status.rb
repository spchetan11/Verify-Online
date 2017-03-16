class VerificationStatus < ActiveRecord::Base

	has_many :verification_requests
	def to_s
		description
	end
end
