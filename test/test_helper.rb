ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require_relative "test_helpers/session_test_helper"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def attach_test_image(record, name: :images)
      record.public_send(name).attach(
        io: file_fixture("photo.png").open,
        filename: "photo.png",
        content_type: "image/png"
      )
    end
  end
end
