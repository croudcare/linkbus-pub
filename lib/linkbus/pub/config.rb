module Linkbus
  module Pub
    module Config

      class Options
        attr_writer :host, :port, :user, :password, :bus, :vhost
        
        def host
          @host || '127.0.0.1'
        end

        def port
          @port || 5672
        end

        def user
          @user || 'guest'
        end

        def password
          @password || 'guest'
        end

        def bus
          @bus || 'bus'
        end

        def vhost
          @vhost || '/'
        end

        def to_hash
          { 
            :host => host,
            :port => port,
            :user => user,
            :password => password,
            :vhost => vhost
          }
        end

      end

      def self.options 
        @options ||= Options.new
      end

      def self.setup(&block)
        block.call(options)
      end

    end
  end
end 


Linkbus::Pub::Config.setup do |config| 
  config.host = '127.0.0.1'
  config.port = 5672
  config.user = 'guest'
  config.password = 'guest'
  config.bus = 'back'
  config.vhost = '/'
end


# class User
#   include Linkbus::Pub::Publisher

#   def xpto
#     publish(key, message)
#   end

# end