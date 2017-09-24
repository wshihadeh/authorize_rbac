AuthorizeRbac.configure do |config|
  config.current_user_method = "current_user"
  config.default_controller = "admin"
  config.default_action = "index"
end
