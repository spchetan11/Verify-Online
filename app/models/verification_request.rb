class VerificationRequest < ActiveRecord::Base
	include Tokenable
	
	belongs_to :user
	belongs_to :college
	belongs_to :verification_status
	belongs_to :payment

	def self.search(search)
	  if search
	    where('name LIKE ?', "%#{search}%")
	  else
	    all 
	  end
	end

end
