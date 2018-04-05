Capybara.asset_host = 'http://localhost:3000'

require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, { debug: true, js_errors: true })
end

Capybara.javascript_driver = :poltergeist