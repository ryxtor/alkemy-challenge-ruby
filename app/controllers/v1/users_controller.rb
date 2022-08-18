class V1::UsersController < ApplicationController
  def add
    valid, error, status = UsersHelper::Validator.valid_credentials?(params[:email], params[:password])
    unless valid
      render json: { 'error:': error }, status: status
      return
    end
    user = User.new(email: params[:email], name: params[:name] || '',
                    password: UsersHelper::Hash.encrypt(params[:password]))
    if user.valid?
      user.save
      NotifierMailer.send_signup_email(user).deliver_now
      render json: user.to_json(only: %I[name email token]), status: :ok
    else
      render json: { 'error:': user.errors.first.message }, status: :bad_request
    end
  rescue StandardError => e
    render json: { 'error:': e }, status: :bad_request
  end

  def authenticate
    user = User.find_by_email(params[:email])
    unless user
      render json: { 'error:': 'User does not exist' }, status: :unauthorized
      return
    end
    if UsersHelper::Hash.valid?(params[:password], user.password)
      render json: user.to_json(only: %I[name email token]), status: :ok
    else
      render json: { 'error:': 'Invalid Password' }, status: :unauthorized
    end
  rescue StandardError => e
    render json: { 'error:': e }, status: :bad_request
  end
end
