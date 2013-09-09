module Linkbus::Pub::Publisher

  def puberror
    @errors || []
  end

  def publish(key, message)
    Linkbus::Pub::log_info("Publishing to [ #{key} ] message [ #{message} ]")
   
    valid_to_publish!(key, message)
    to_publish(key, message)
    return puberror.empty?
   
    rescue StandardError => e
      Linkbus::Pub::log_fatal("Exception #{ e.message } -- #{ e.backtrace }")
      puberror.push(e)
      return false
  end

  private

  def to_publish(key, message)
    with_exchange do | topic | 
     
      topic.publish(message, :routing_key => key, :mandatory => true, :persistent => true)
      Linkbus::Pub::log_info("Message Published  key:  [ #{key} ], message: [ #{message} ]")

      topic.on_return do |basic_deliver, properties, content|
        Linkbus::Pub::log_fatal("MESSAGE NOT ROUTED  [ #{key} ] message [ #{message} ]")
        puberror.push("Message not routed #{message} key: #{key}")
      end
    end

  end

  def valid_to_publish!(key, message)
    raise ArgumentError, "key cannot be nil" if key.nil?
  end

  def clear_errors
    @errors = []
  end

  def start_bunny_client(&block)
    client = Bunny.new(:host => Linkbus::Pub::Config.options.host, :user => Linkbus::Pub::Config.options.user, :password => Linkbus::Pub::Config.options.password, :vhost =>Linkbus::Pub::Config.options.vhost)
    client.start
    block.call(client)
    ensure
    client.close if client
  end

  def setup_to_publish(&block)
    clear_errors
    start_bunny_client &block
  end

  # https://github.com/ruby-amqp/bunny/blob/master/spec/higher_level_api/integration/basic_return_spec.rb
  # sleep is how bunny spec do.
  def with_exchange(&block)
    setup_to_publish do | client | 
      block.call( create_topic(client) ) 
      sleep 0.1 if puberror.empty?
    end
  end

  def create_topic(client)
    Linkbus::Pub::log_info("Creating topic to exchange [ #{Linkbus::Pub::Config.options.bus} ]")
    channel  = client.create_channel
    channel.topic(Linkbus::Pub::Config.options.bus, :durable => true)
  end

end