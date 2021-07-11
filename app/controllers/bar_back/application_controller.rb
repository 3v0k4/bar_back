module BarBack
  class ApplicationController < ActionController::Base
    before_action :authenticate, if: -> { BarBack.http_basic_enabled }

    private

    def authenticate
      request_http_basic_authentication unless authenticated
    end

    def authenticated
      authenticate_with_http_basic do |username, password|
        ActiveSupport::SecurityUtils.secure_compare(username, BarBack.http_basic_username) &&
          ActiveSupport::SecurityUtils.secure_compare(password, BarBack.http_basic_password)
      end
    end
  end
end
