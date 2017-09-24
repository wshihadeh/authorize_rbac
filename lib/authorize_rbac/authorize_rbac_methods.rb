module AuthorizeRbac
  module AuthorizeRbacMethods
    def self.extended(base)
      class <<base
        @rbac = {}
        attr_reader :rbac
      end
    end

    def roles(*roles)
      @roles = roles
    end

    def method_added(method)
      return if private_method_defined? method
      access_list[method] = @roles
      @roles = nil
    end

    def access_list
      @rbac ||= {}
    end
  end
end
