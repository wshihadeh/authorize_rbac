require "spec_helper"

module AuthorizeRbac
  class DummyClass
    self.extend(AuthorizeRbac::AuthorizeRbacMethods)
    include AuthorizeRbac::AuthorizeRbacMethods

    roles :admin
    def admin_only
      "admin"
    end

    roles :admin, :user
    def admin_and_user
      "admin_and_user"
    end

    def all
      "all"
    end

    private

    def unused
     "unused"
    end
  end
end

describe AuthorizeRbac::DummyClass do
  before(:each) do
    @dummy = AuthorizeRbac::DummyClass.new
  end

  it "include module methods" do
    expect(@dummy.methods).to include(:method_added, :access_list, :roles)
  end

  it "include public methods in the access list" do
     expect(AuthorizeRbac::DummyClass.rbac.keys).to include(:admin_only, :admin_only, :all)
  end

  it "does not include private methods in the access list" do
     expect(AuthorizeRbac::DummyClass.rbac.keys).to_not include(:unused)
  end

  it "uses nil as default value" do
     expect(AuthorizeRbac::DummyClass.rbac[:all]).to eq(nil)
  end

  it "map the roles to the access list" do
     expect(AuthorizeRbac::DummyClass.rbac[:admin_only]).to eq([:admin])
     expect(AuthorizeRbac::DummyClass.rbac[:admin_and_user]).to eq([:admin, :user])
  end
end
