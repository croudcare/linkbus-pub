module Linkbus
  module Pub
    module Config

      class Options
        attr_writer :host, :port, :user, :password, :bus, :vhost, :log_file
        
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

        def log_file
          @log_file || "log/linkbus.log"
        end

        def to_hash
          { 
            :host => host,
            :port => port,
            :user => user,
            :password => password,
            :vhost => vhost,
            :log_file => log_file
          }
        end

      end

      def self.options 
        @options ||= Options.new
      end
      
      def self.[](val)
        options.send(val)
      end

      def self.setup(&block)
        block.call(options)
        Linkbus::Pub::log_info("Configured with options #{options.to_hash}")
      end

    end
  end
end 


# class User
#   include Linkbus::Pub::Publisher

#   def xpto
#     publish(key, message)
#   end

# end