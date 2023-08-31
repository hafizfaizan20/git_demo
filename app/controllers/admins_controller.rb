class AdminsController < ApplicationController
  before_action :authenticate_admin!

  def index
    status_controller = StatusController.new
    status_controller.get_users
    @users = status_controller.instance_variable_get('@users')
  end

  def show_all_users
    status_controller = StatusController.new
    status_controller.get_all_users
    @users = status_controller.instance_variable_get('@users')
  end
  
end
