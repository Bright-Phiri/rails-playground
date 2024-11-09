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

  def authorize_request
    token = auth_header.split(' ').last if auth_header
  
    decoded_token = decode_token(token)
  
    email = decoded_token[0]['email'] if decoded_token
    account_type = decoded_token[0]['type'] if decoded_token
  
    user = case account_type
           when 'User'
             User.find_by(email: email)
           when 'Voter'
             Voter.find_by(email: email)
           else
             nil
           end
    unless user
      render json: { error: 'Unauthorized' }, status: :unauthorized
      return
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
