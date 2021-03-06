module Webpacker; end
require "webpacker/dev_server_proxy"

module BarBack
  class Engine < ::Rails::Engine
    isolate_namespace BarBack

    initializer "bar_back.assets.precompile" do |app|
      app.config.assets.precompile += ["bar_back/logo.svg"]
    end

    config.app_middleware.use(
      Rack::Static,
      urls: ["/packs", "/packs-test"], root: BarBack::Engine.root.join("public")
    )

    initializer "webpacker.proxy" do |app|
      insert_middleware =
        begin
          BarBack.webpacker.config.dev_server.present?
        rescue => e
          puts e
          nil
        end
      next unless insert_middleware

      app.middleware.insert_before(
        0,
        Webpacker::DevServerProxy,
        ssl_verify_none: true,
        webpacker: BarBack.webpacker
      )
    end
  end
end
