require "webpacker"
require "webpacker/helper"

module BarBack
  module ApplicationHelper
    include ::Webpacker::Helper

    def current_webpacker_instance
      BarBack.webpacker
    end
  end
end

