require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  DOWNLOAD_PATH = Rails.root.join("tmp/downloads")

  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400] do |option|
    option.add_preference("download.default_directory", DOWNLOAD_PATH)
  end

  teardown do
    FileUtils.rm(Dir.glob("#{DOWNLOAD_PATH}/*.csv"))
  end
end
