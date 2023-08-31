class UserMailer < ApplicationMailer
  def send_email_to_user(user)
    @user = User.find(user)
    mail(to: @user.email, subject: 'Testing email')
  end
end
