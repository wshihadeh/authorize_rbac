require 'rails/generators'
module AuthorizeRbac
  class AuthorizeRbacGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../', __FILE__)
    ACTIONS = %w(intall user_migrate role_migrate update_application_controller update_user_model initializer help).freeze
    def generate_controllers
      ACTIONS.include?(action_name) ?  self.send(action_name) : help
    end

    private
    def action_name
      name.to_s.downcase
    end

    def install
      user_migrate
      role_migrate
      update_application_controller
      update_user_model
    end

    def initializer
       copy_file "#{AuthorizeRbacGenerator.source_root}/templates/initializer.rb", "config/initializers/authorize_rbac.rb"
    end

    def user_migrate
      generate "migration", "AddRoleToUsers role:references"
    end

    def role_migrate
      generate "model", "Role name:string permissions:text"
      update_role_model
    end

    def update_application_controller
      inject_into_file 'app/controllers/application_controller.rb',
        "  include AuthorizeRbac\n",
        after: "class ApplicationController < ActionController::Base\n"

      inject_into_file 'app/controllers/application_controller.rb',
        "  before_action :authorization_filter, except: [ :logout ]\n",
        after: "protect_from_forgery with: :exception\n"
    end

    def update_user_model
      inject_into_file 'app/models/user.rb',
        " belongs_to :role\n",
        after: "class User < ActiveRecord::Base\n"
    end

    def update_role_model
      inject_into_file 'app/models/role.rb',
        " serialize :permissions, JSON\n",
        after: "class Role < ApplicationRecord\n"
    end

    def help
      puts File.read "#{AuthorizeRbacGenerator.source_root}/USAGE"
    end
  end
end
