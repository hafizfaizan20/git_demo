class StatusController < ApplicationController
  
  def get_users
    @users = User.where(status: false)
    # redirect_to authenticated_admin_root_path, @users = @users
  end

  def get_all_users
    @users = User.all
  end

  def accept
    user = User.find(params[:id])
    user.update(status: true)
    redirect_to authenticated_admin_root_path, notice: "User #{user.name} accepted."
  end

  def reject
    user = User.find(params[:id])
    user.pdfs.delete_all
    user.delete
    redirect_to authenticated_admin_root_path, notice: "User #{user.name} Rejected."
  end
  
end
