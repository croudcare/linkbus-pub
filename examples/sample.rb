
Linkbus::Pub::Config.setup do |config| 
  
  config.host     = '127.0.0.1'
  config.port     = 5672
  config.user     = 'guest'
  config.password = 'guest'
  config.bus      = 'bus'
  config.vhost    = '/'
  config.log_file = 'linkbus.log'

end

class MedicCreatedPublisher
  include Linkbus::Pub::Publisher

  def initialize(medic)
    @medic = medic
  end
  
  def broadcast
    publish('medic.update', build_medic_message)
  end

  private

  def build_medic_message
    [@medic.id, @medic.name].join("::")
  end

end


class Medic

  attr_accessor :name, :id
  def initialize(name)
    @name = name
  end
  
  def save
    @id = 123893
    #SAVE TO DATABASE
    after_commit
  end

  def after_commit
    MedicCreatedPublisher.new(self).broadcast
  end

end

m = Medic.new("thiago dantas")

if m.save
    puts "Message Published"
else
  puts "Not Published"
end