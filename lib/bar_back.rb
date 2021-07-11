require "bar_back/version"
require "bar_back/engine"

module BarBack
  mattr_accessor :http_basic_enabled
  mattr_accessor :http_basic_username
  mattr_accessor :http_basic_password

  ROOT_PATH = Pathname.new(File.join(__dir__, ".."))

  class << self
    def webpacker
      @webpacker ||= ::Webpacker::Instance.new(
        root_path: ROOT_PATH,
        config_path: ROOT_PATH.join("config/webpacker.yml")
      )
    end
  end
end
