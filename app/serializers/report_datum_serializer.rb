class ReportDatumSerializer < ActiveModel::Serializer
  attributes :id, :from_address, :to_address, :letter_title, :subject, :body, :designation, :header, :signature
  has_one :college
end
