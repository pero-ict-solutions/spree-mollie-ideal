module Spree
  module SpreeMollie
    class Engine < Rails::Engine
      engine_name 'spree_mollie'

      config.autoload_paths += %W(#{config.root}/lib)

      # use rspec for tests
      config.generators do |g|
        g.test_framework :rspec
      end

      def self.activate
        Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
      end

      config.after_initialize do |app|
        app.config.spree.payment_methods += [
          Spree::PaymentMethod::MollieIdeal
         ]
      end

      config.to_prepare &method(:activate).to_proc
    end
  end
end
