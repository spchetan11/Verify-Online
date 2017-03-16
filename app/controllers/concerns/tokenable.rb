module Tokenable
  extend ActiveSupport::Concern

  included do
    before_create :generate_token
  end

  protected

  def generate_token
    self.verification_token = loop do
      # random_token = SecureRandom.base64(5).gsub("/","_").gsub(/=+$/,"")
      random_token = rand(36**7).to_s(36)
      break random_token unless self.class.exists?(verification_token: random_token)
    end
  end
end