Capybara.asset_host = 'http://localhost:3000'

Capybara.register_driver(:headless_chrome) do |app|
  headless_capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[headless disable-gpu --window-size=1024,768] }
  )

  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[disable-gpu --window-size=1024,768] }
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    desired_capabilities: ENV['VISUAL'] ? capabilities : headless_capabilities
  )
end

Capybara.javascript_driver = :headless_chrome
