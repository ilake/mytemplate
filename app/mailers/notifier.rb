class Notifier < ActionMailer::Base
  def password_reset_instructions(user)
    @edit_password_reset_url = edit_password_reset_url(user.perishable_token)
    mail(:to => named_email(user), :subject => "Liveplus - Password Reset Instructions")
  end

  #be sent after the user is actived
  def welcome_information(user)
    @account = user
    mail(:to => named_email(user), :subject => "Liveplus - Welcome")
  end

  def activation_instructions(user)
    @account_activation_url = activate_url(user.perishable_token)
    mail(:to => named_email(user), :subject => "Liveplus - Activation Instructions")
  end

  private
  def named_email(user)
    "#{user.nickname} <#{user.email}>"
  end
end
