Rails.application.configure do
  config.assets.version = '1.0'
  config.assets.precompile += %w(application.js stub_modules/*.js)
end
