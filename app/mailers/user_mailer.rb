class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @user = user
    address = Mail::Address.new "support@veryfyonline.in"
    address.display_name = "VerifyOnline.in Support"
    mail from: address.format, to: user.email, subject: "Account activation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    address = Mail::Address.new "support@veryfyonline.in"
    address.display_name = "VerifyOnline.in Support"
    mail from: address.format, to: user.email, subject: "Password reset"
  end
end
