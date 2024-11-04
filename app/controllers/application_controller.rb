# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ExceptionHandler
  before_action :authorize_request, :set_url_options

  def set_url_options
    Rails.application.default_url_options[:host] = request.host_with_port
  end

  def encode_token(payload)
    JWT.encode(payload, hmac_secret)
  end

  def logged_in?
    logged_in_user.present?
  end

  def logged_in_user
    return unless decoded_token
    
    voter_email = decoded_token[0]['email']
    Voter.find_by(email: voter_email)
  end

  def authorize_request
    if auth_header.blank?
      render_unauthorized 'Token missing'
    else
      render_unauthorized 'Invalid token format' and return unless auth_header.starts_with?('Bearer ')
      render_unauthorized 'Unauthorized: Invalid or expired token' unless logged_in?
    end
  end

  def auth_header
    request.authorization
  end

  def decode_token(token)
    JWT.decode(token, hmac_secret, true, { algorithm: 'HS256' })
  rescue JWT::DecodeError
    nil
  end

  def decoded_token
    token = auth_header.split(' ')[1]
    decode_token(token)
  end

  def render_unauthorized(message)
    render json: { status: 'login', message: }, status: :unauthorized
  end

  def hmac_secret
    Rails.application.credentials.secret_key_base
  end

  def render_error(message = 'OK', data = nil, errors = nil)
    render status: :ok, json: error_response_body(message, data, errors)
  end
  
  def render_ok(data, message = 'OK')
    render status: :ok, json: success_response_body(data, message)
  end
  
  def render_created(data, message = 'Created')
    render status: :created, json: success_response_body(data, message)
  end
  
  def render_bad_request(message = 'Bad Request', errors)
    render status: :bad_request, json: error_response_body(message, nil, errors)
  end
  
  def render_forbidden(message = 'Forbidden', errors)
    render status: :forbidden, json: error_response_body(message, nil, errors)
  end
  
  def render_unprocessable_entity(message = 'Unprocessable Entity', errors)
    render status: :unprocessable_entity, json: error_response_body(message, nil, errors)
  end

  def render_not_found(message = 'Not Found', errors)
    render status: :unprocessable_entity, json: error_response_body(message, nil, errors)
  end
  
  private

  def success_response_body(data, message = 'OK', errors = nil)
    {
      success: true,
      message: message,
      data: data,
      errors: errors
    }
  end
  
  def error_response_body(message, data = nil, errors = nil)
    {
      success: false,
      message: message,
      data: data,
      errors: errors
    }
  end
end
