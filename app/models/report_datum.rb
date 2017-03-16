class ReportDatum < ActiveRecord::Base
  belongs_to :college

  has_attached_file :header, styles: {
	    medium: "1000x200>"
	}, default_url: "https://s3-ap-southeast-1.amazonaws.com/verifyonline-documents/header_default.png"
  has_attached_file :signature, styles: {
	    medium: '200x100>'
	}, default_url: "https://s3-ap-southeast-1.amazonaws.com/verifyonline-documents/signature_default.png"
  validates_attachment_content_type :header, :content_type => /\Aimage\/.*\Z/
  validates_attachment_content_type :signature, :content_type => /\Aimage\/.*\Z/
end
