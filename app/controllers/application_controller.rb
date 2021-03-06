class ApplicationController < ActionController::API
  acts_as_token_authentication_handler_for User, fallback: :none
  respond_to :json
  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    attributes = [:kind]
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
    devise_parameter_sanitizer.permit(:account_update, keys: attributes)
  end

  def render_not_found model_name
    render json: { error: "Não encontrado." }, status: :not_found
  end

end
