class College < ActiveRecord::Base

# Associations
belongs_to :user
has_one :report_datum
has_many :verification_requests


end
