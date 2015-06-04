require 'rabbitmq/http/client'

 module Lita
  module Handlers
  class MQ < Handler

  route(/^mqstat\s+(.+)/i, :mqstat, command: true, restrict_to: :sysops)  
  
    def mqstat(response)

        server = response.matches[0][0] 
        http = 'http://'
        port = ':15672'
        client = RabbitMQ::HTTP::Client.new("#{http}" + "#{server}" + "#{port}", :username => "guest", :password => "guest")
        nodes = client.list_nodes
        n = nodes.first
        
        a = n.sockets_used
        b = n.mem_used
        c = n.run_queue
         
        xs = client.list_exchanges
        x = xs.first
        d = x.type
        e = x.name
        f = x.vhost
        g = x.durable
        #nodes1 = client.node_info("rabbit@localhost")
        #defs = client.list_definitions
         


        response.reply("Sockets:> " + "#{a}", "Memory used:> " + "#{a}", "Run Queue:> " + "#{c}")
    end

  Lita.register_handler(MQ)

  end
  end
  end
