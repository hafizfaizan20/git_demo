require 'csv'
class Api::UsersController < ApplicationController
  def export_users
    @users = User.where(status: true)

    csv_data = CSV.generate(headers: true) do |csv|
      csv << User.column_names
      @users.each do |user|
        csv << user.attributes.values
        UserEmailJob.perform_in(1.minutes, user.id)
      end
    end

    puts csv_data

    file_path = Rails.root.join('public', 'users.csv')
    File.write(file_path, csv_data)
    render json: { csv_url: "/users.csv" }
  end
end
