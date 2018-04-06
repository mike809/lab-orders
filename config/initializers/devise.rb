Devise.setup do |config|
  require 'devise/orm/active_record'

  config.secret_key = ENV['DEVISE_SECRET_KEY'] if Rails.env.production?
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 11
  config.expire_all_remember_me_on_sign_out = true
  config.sign_out_via = :delete

  config.parent_controller = 'ActionController::Base'
  config.omniauth :azure_oauth2,
                  client_id: ENV['AZURE_CLIENT_ID'],
                  client_secret: ENV['AZURE_CLIENT_SECRET'],
                  tenant_id: ENV['AZURE_TENANT_ID']

  config.warden do |manager|
    manager.failure_app = CustomAuthenticationFailure
  end
end
