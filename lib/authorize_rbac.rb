require "authorize_rbac/version"
require "authorize_rbac/authorize_rbac_methods"
require "authorize_rbac/configuration"
require 'rails'

module AuthorizeRbac
  def self.included(base)
    base.extend(AuthorizeRbacMethods)
  end

  def self.configuration
    @configration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def authorization_filter
    if access_allowed?
      logger.debug "Authorized to access #{request.original_url}, User: #{auth_user.user_name} (role: #{user_role})"
      return true
    else
      logger.info "#{auth_user.user_name} (role: #{user_role}) attempted to access\
        #{self.class}##{action_name} without the proper permissions."
      flash[:notice] = "Not authorized to access #{request.original_url}!"
      redirect_to :controller => AuthorizeRbac.configuration.default_controller , :action => AuthorizeRbac.configuration.default_action
      return false
    end
  end

  def user_role
    auth_user.role.nil? ? "user" : auth_user.role.name.to_s
  end

  def action_roles
    self.class.rbac[action_name]
  end

  def action_name
    request.parameters[:action].to_sym
  end

  def access_allowed?
    return true if action_roles.nil?

    allowed_from_source = action_roles.include? user_role.to_sym
    allowed_from_db     = user_permissions.include?(permission_name(self.class, action_name))

    allowed_from_source || allowed_from_db
  end

  def permission_name(cotroller, action)
    "#{cotroller.to_s.chomp("Controller").downcase}_#{action}"
  end

  def auth_user
    self.send(AuthorizeRbac.configuration.current_user_method)
  end

  def user_permissions
    auth_user.role.permissions
  end
end
