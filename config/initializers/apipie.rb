Apipie.configure do |config|
  config.app_name                = "TheatreCity17Api"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/apipie"
  # where is your API defined?
  config.default_version         = 'v1'
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.app_info                 = 'This is the API for TheatreCity17Api'
end
