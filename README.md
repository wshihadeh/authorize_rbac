# AuthorizeRbac

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'authorize_rbac'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install authorize_rbac

## Usage

- Generate necessary changes
  - You can generate all migration using the follwing command

    ```
      bundle exec rails g authorize_rbac install
    ```

  - Or you can do it one by one

    ```
    bundle exec rails g authorize_rbac user_migrate
    bundle exec rails g authorize_rbac role_migrate
    bundle exec rails g authorize_rbac update_application_controller
    bundle exec rails g authorize_rbac update_user_model
    bundle exec rails g authorize_rbac initializer
    ```

  - Generator help
    ```
    bundle exec rails g authorize_rbac user_migrate
    ```

- Check the generated files and update them if necessary
- Execute migration
  ```
  bundle exec rake db:migrate
  ```

- Update Controller Methods with the allowed roles
  ```
   class MyController < ApplicationController

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
  end
  ```

  - Default role is user, you need to update the registration process to assign users to roles.
  - if roles is not defined for a given action, then the action is allowed for all users.
  - To add a dynamic permission for a given role from rails console, use the following commands
  ```
  $-> role = Role.find :id
  $-> role.permissions = [:admin_index]
  $-> role.save

  ```
- role.permissions is an array of all allowed actions. The items of this array are constructed with the following schema "#{controller_name}_#{action_name}". for instance, to allow the action `users` on `AdminController`, you need to add this to the permissions list `:admin_users`.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
