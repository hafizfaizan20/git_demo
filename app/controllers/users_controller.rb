class UsersController < ApplicationController
  require 'rubygems'
  require 'twilio-ruby'
  
  before_action :authenticate_user!
  
  def index
  end

  def edit_details
    @user = current_user
  end

  def update_details
    @user = current_user
    if @user.update(user_params)
      verification_code = rand(1000..9999) # Generate a random 4-digit code
      @user.update(verification_code: verification_code)
      send_verification_sms(@user.phone, verification_code)
      redirect_to verification_page_user_path, notice: "Details updated successfully and verification code has been sent"
    else
      render 'edit_details'
    end
  end

  def verification_page
    @user = current_user
  end

  def verify_code
    @user = current_user
    if params[:code] == @user.verification_code
      redirect_to upload_pdf_user_path, notice: "Phone number verified successfully!"
    else
      render 'verification_page', notice: "Incorrect verification code."
    end
  end

  def upload_pdf
    @user = current_user
  end

  def save_pdf
    @user = current_user
    if @user.pdfs.length < 2
      @user.pdfs.attach(params[:user][:pdf])
      redirect_to upload_pdf_user_path(@user), notice: "PDF file uploaded successfully!"
    else
      redirect_to root_path, alert: "You have already uploaded two PDF files."
    end
  end

  def show_pdf
    @user = current_user
  end

  private

  def send_verification_sms(phone, code)
    account_sid = "ACe976675e6103ebd810b6c92bf31e2b3d"
    auth_token = "70622fc51f7f1fa6427e44c2593fbacf"
    @client = Twilio::REST::Client.new account_sid, auth_token
    @client.messages.create(
      to: phone,
      from:'+16184378496',
      body: "Your verification code: #{code}"
    )
  end

  def user_params
    params.require(:user).permit(:name, :phone, :cnic, :address)
  end
end
