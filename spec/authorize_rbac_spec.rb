require "spec_helper"

describe AuthorizeRbac do
  it "has a version number" do
    expect(AuthorizeRbac::VERSION).not_to be nil
  end

  it "store configurations" do
    AuthorizeRbac.configure do |config|
      config.current_user_method = "current_user"
      config.default_controller = "admin"
      config.default_action = "index"
    end

    expect(AuthorizeRbac.configuration.current_user_method).to eq("current_user")
    expect(AuthorizeRbac.configuration.default_controller).to eq("admin")
    expect(AuthorizeRbac.configuration.default_action).to eq("index")
  end
end
