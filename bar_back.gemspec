require_relative "lib/bar_back/version"

Gem::Specification.new do |spec|
  spec.name        = "bar_back"
  spec.version     = BarBack::VERSION
  spec.authors     = ["3v0k4"]
  spec.email       = ["riccardo.odone@gmail.com"]
  spec.homepage    = "https://github.com/3v0k4/bar_back"
  spec.summary     = "BarBack is the Rails console you can share with non technical people"
  spec.description = <<~DESCRIPTION
    BackOffice enables you to:

    - execute an ActiveRecord read query;
    - save an ActiveRecord read query for later;
    - view the query result and update records behind HTTP basic authentication;
    - share the query result with anybody via a link that contains a random UUID;
    - export the query result to CSV.
  DESCRIPTION
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/3v0k4/bar_back"
  spec.metadata["changelog_uri"] = "https://github.com/3v0k4/bar_back/CHANGELOG.md"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 6.0", "< 7"
  spec.add_dependency "webpacker", "6.0.0.rc.5"
end
