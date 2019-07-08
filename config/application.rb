require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Petsy
  class Application < Rails::Application
    #config.load_defaults 5.2 
    #Je ne veux pas generer les assets, les helpers; je n'utilise pas de frame_work de test et je n'utilise pas jbuilder

    
    config.site = {
      name: 'Petsy'
    }


    config.generators do |g|
      g.assets false
      g.helpers false
      g.test_framework false
      g.jbuilder false
    end
  end
end
