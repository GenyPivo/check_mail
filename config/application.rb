require_relative 'boot'

require 'action_controller/railtie'
require 'active_model/railtie'
require 'action_view/railtie'
require 'resolv'
require 'net/smtp'
require 'will_paginate/array'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ralabs
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.autoload_paths << Rails.root.join('app/services')
    config.autoload_paths << Rails.root.join('app/validations')

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
