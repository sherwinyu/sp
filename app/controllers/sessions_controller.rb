class SessionsController < ApplicationController
  respond_to :json

  def create
    @user = User.first
    password = params[:user][:password]
    if @user && @user.valid_password?(password)
      sign_in @user
      render json: @user, status: :created
    else
      render json: {
        errors: {
          email: "invalid email or password"
        }
      }, status: 401
    end
  end

  def destroy
    binding.pry
=begin
      signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
      render json: {
        'csrf-param' => request_forgery_protection_token,
        'csrf-token' => form_authenticity_token
      }
    signed_out =
=end
  end

end
