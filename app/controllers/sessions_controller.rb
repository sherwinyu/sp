class SessionsController < ApplicationController
  respond_to :json

  def create
    @user = User.find_by email: params[:user][:email]
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
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    # TODO(syu): update client side csrf tokens
    render json: {
      'csrf-param' => request_forgery_protection_token,
      'csrf-token' => form_authenticity_token
    }
  end

  def new
    redirect_to '/#/login'
  end


end
