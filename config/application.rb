require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Isc434
  class Application < Rails::Application

    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: false,
        request_specs: false
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end

    config.load_defaults 5.1

    config.session_store :cookie_store, key: '_interslice_session'
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore, config.session_options
    config.autoload_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('lib')
    config.active_record.schema_format = :sql

    config.browserify_rails.commandline_options = '-t [ babelify --presets [ env ] ]'
    config.browserify_rails.force = true
    unless Rails.env.production?
      config.browserify_rails.paths << lambda { |p|
        p.start_with?(Rails.root.join('spec/javascripts').to_s)
      }
    end
  end
end
