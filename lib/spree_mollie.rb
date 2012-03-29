require 'spree_core'
require 'spree_mollie/engine'

Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
  Rails.configuration.cache_classes ? require(c) : load(c)
end
