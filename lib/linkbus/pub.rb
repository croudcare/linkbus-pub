module Linkbus
  module Pub
    
    def self.log_info(message)
      Linkbus::Pub::Logging.info message
    end

    def self.log_fatal(message)
      Linkbus::Pub::Logging.fatal message
    end
  
  end
end

require 'bunny'
require 'linkbus/pub/logging'
require 'linkbus/pub/version'
require 'linkbus/pub/publisher'
require 'linkbus/pub/config'
