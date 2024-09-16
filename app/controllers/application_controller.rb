class ApplicationController < ActionController::API
    def authorize_request
      header = request.headers['Authorization']
      header = header.split(' ').last if header
      decoded = decode_token(header)
      @current_user = User.find(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: { errors: 'Unauthorized' }, status: :unauthorized
    end
  
    def decode_token(token)
      JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
    end
end
  