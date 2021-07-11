require 'rails/generators/base'

module BarBack
  class InstallGenerator < Rails::Generators::Base
    desc "Creates initializer and adds a route to your application."

    def create_initializer
      initializer "bar_back.rb", <<~EOF
        BarBack.http_basic_enabled = true
        BarBack.http_basic_username = "#{SecureRandom.alphanumeric(10)}"
        BarBack.http_basic_password = "#{SecureRandom.alphanumeric(10)}"
      EOF
    end

    def create_route
      route 'mount BarBack::Engine => "/bar_back"'
    end

    def install_migrations
      rake "bar_back:install:migrations"
    end
  end
end
