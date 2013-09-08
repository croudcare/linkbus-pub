require 'bunny'

module Linkbus
  module Pub  
    module Publisher

      def puberror
        @errors || []
      end

      def publish(key, message)
        raise ArgumentError, "key cannot be nil" if key.nil?
        with_exchange do |topic| 
          puts "Publishing to #{key}"
          p "#{Linkbus::Pub::Config.options.to_hash}"
          topic.publish(message, :routing_key => key, :mandatory => true)
        end
        return puberror.empty?
        rescue StandardError => e
          puberror.push(e)
          return false
      end

      private

      def clear_errors
        @errors = []
      end

      def start_bunny_client
       @client = Bunny.new(:host => Linkbus::Pub::Config.options.host, :user => Linkbus::Pub::Config.options.user, :password => Linkbus::Pub::Config.options.password, :vhost =>Linkbus::Pub::Config.options.vhost)
       @client.start
      end

      def setup_to_publish
        clear_errors
        start_bunny_client 
      end

      def with_exchange(&block)
        setup_to_publish
        block.call( create_topic(@client) ) if block_given?
        # https://github.com/ruby-amqp/bunny/blob/master/spec/higher_level_api/integration/basic_return_spec.rb
        # sleep is how bunny spec do
        sleep 0.2 if puberror.empty?
        ensure
        @client.close
      end

      def create_topic(connection)
        channel  = connection.create_channel
        topic = channel.topic(Linkbus::Pub::Config.options.bus, :durable => true)
        topic.on_return do |basic_deliver, properties, content|
          puberror.push('Message not routed')
        end
        topic
      end
      
    end
  end
end