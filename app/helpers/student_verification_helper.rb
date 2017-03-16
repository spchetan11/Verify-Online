module StudentVerificationHelper

	def verifyChecksum( merchantID,  orderID,  amount,  authDesc,  workingKey,  checksum) 

		String str = merchantID+“|”+orderID+“|”+amount+“|”+authDesc+“|”+workingKey

		String newChecksum = Zlib::adler32(str).to_s

		return (newChecksum.eql?(checksum)) ? true : false

	end

	def getChecksum( merchantID,  orderID,  amount,  redirectUrl,  workingKey) 

		String str = merchantID + “|” + orderID + “|” + amount + “|” + redirectUrl + “|” + workingKey;

		return Zlib::adler32(str)

	end

	def encrypt_string(ccaRequest)
		Dir.chdir("#{RAILS_ROOT}/public/jars/") do

	      encRequest = %x[java -jar ccavutil.jar #{CCAVENUE_WORKING_KEY} "#{ccaRequest}" enc]

	    end
	    return encRequest
	end
	
	def decrypt_string(encRequest)
		Dir.chdir("#{RAILS_ROOT}/public/jars/") do

       		ccaResponse = %x[java -jar ravi-ccavutil.jar #{CCAVENUE_WORKING_KEY} "#{encResponse}" dec]

		end
	    return ccaResponse
	end


	def sortable(column, title = nil)
	  title ||= column.titleize
	  css_class = column == sort_column ? "current #{sort_direction}" : nil
	  direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
	  link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
	end


end
