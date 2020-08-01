require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.hosts << '.teleboat-agent'
    config.hosts << '.boatrace-docker_default'

    config.x.application_token = ENV.fetch('TELEBOAT_AGENT_API_APPLICATION_TOKEN') { '*****' }

    config.x.teleboat_member_number = ENV.fetch('TELEBOAT_MEMBER_NUMBER') { '*****' }
    config.x.teleboat_pin = ENV.fetch('TELEBOAT_PIN') { '*****' }
    config.x.teleboat_authorization_password = ENV.fetch('TELEBOAT_AUTHORIZATION_PASSWORD') { '*****' }
    config.x.teleboat_authorization_number_of_mobile = ENV.fetch('TELEBOAT_AUTHORIZATION_NUMBER_OF_MOBILE') { '*****' }
  end
end
