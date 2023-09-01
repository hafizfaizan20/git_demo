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
    puts current_admin.email
    admin = current_admin.email
    directory_path = Rails.root.join('public', admin)
    
    unless File.directory?(directory_path)
      FileUtils.mkdir_p(directory_path)  
    end

    file_path = directory_path.join('users.csv')
    File.write(file_path, csv_data)
    render json: { csv_url: "/users.csv" }
  end
end
