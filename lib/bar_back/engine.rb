module BarBack
  class Engine < ::Rails::Engine
    isolate_namespace BarBack

    config.app_middleware.use(
      Rack::Static,
      urls: ["/bar_back-packs", "/packs-test"], root: BarBack::Engine.root.join("public")
    )

    initializer "webpacker.proxy" do |app|
      insert_middleware =
        begin
          BarBack.webpacker.config.dev_server.present?
        rescue
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
