require "spec_helper"

describe AuthorizeRbac::Configuration do
  it "has create get accessors for CONFIG_KEYS" do
    config = AuthorizeRbac::Configuration.new

    expect(config.current_user_method).to be nil
    expect(config.default_controller).to be nil
    expect(config.default_action).to be nil
  end

  it "can be accessed using []" do
    config = AuthorizeRbac::Configuration.new
    config.current_user_method = "current_user"

    expect(config[:current_user_method]).to eq("current_user")
  end

  it "throw InvalidKey if the key is not supported" do
    config = AuthorizeRbac::Configuration.new
    expect{ config[:un_supported] = "testval" }.to raise_error(AuthorizeRbac::Configuration::InvalidKey)
  end

  it "has create set accessors for CONFIG_KEYS" do
    config = AuthorizeRbac::Configuration.new

    config.current_user_method = "current_user"
    config.default_controller = "admin"
    config.default_action = "index"

    expect(config.current_user_method).to eq("current_user")
    expect(config.default_controller).to eq("admin")
    expect(config.default_action).to eq("index")
  end
end
