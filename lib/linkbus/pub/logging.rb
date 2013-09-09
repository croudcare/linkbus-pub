require 'logger'
require 'date'

module Linkbus::Pub::Logging

  class Beauty < Logger::Formatter
    def call(severity, time, app, message)
      "[linkbus publisher] #{Time.now.utc} #{Process.pid} #{severity}: #{message}\n"
    end
  end
  
  def self.info(message)
    logger.info(message)
  end

  def self.fatal(message)
    logger.fatal(message)
  end

  def self.setup
    @logger.close if @logger
    @logger = Logger.new(Linkbus::Pub::Config[:log_file])
    @logger.level = Logger::INFO
    @logger.formatter = Beauty.new
    @logger
  end

  def self.logger
    @logger ||= setup
  end

end
