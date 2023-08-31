class UserEmailJob
  include Sidekiq::Job

  queue_as :default

  def perform(user_id)
    UserMailer.send_email_to_user(user_id).deliver_now
  end
end
