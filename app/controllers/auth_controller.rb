class AuthController < ApplicationController
    before_action :authorize_request, except: [:login, :signup]
  
    def signup
      user = User.new(user_params)
      if user.save
        token = encode_token({ user_id: user.id })
        render json: { user: user, token: token }, status: :created
      else
        render json: { error: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def login
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        token = encode_token({ user_id: user.id })
        render json: { user: user, token: token }, status: :ok
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :image)
    end
  
    def encode_token(payload)
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end
  end
  