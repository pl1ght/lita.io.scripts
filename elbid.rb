 module Lita
  module Handlers
  class ELBIDD< Handler
  require 'json'
  require 'curb'
  require 'aws-sdk'                                                                                                                                                                                                  

  route(/^elb show\s+(.+)/i, :elbid, command: true, restrict_to: :sysops, help: {"elb show name " => "elb show instance health for any elb"})  
  
  def elbid(response)
    credentials = Aws::SharedCredentials.new(profile_name: 'ro')
    elb = Aws::ElasticLoadBalancing::Client.new(credentials: credentials, region: 'us-east-1')
    ec2_ids=[]
    elbname = response.matches[0][0]
    # Describe ELB specified
    elbid = elb.describe_load_balancers(options = {:load_balancer_names => ["#{elbname}"]})


  # Grab every instance behind an ELB
  elbid[:load_balancer_descriptions].first[:instances].each do |instance|
    ec2_ids << instance.instance_id
  end

  # Create EC2 Client
  ec2 = Aws::EC2::Client.new(credentials: credentials, region: 'us-east-1')

  response.reply("#{elbname}\n")
  response.reply( "-------------------------------\n")
  # Grab private IP address from each instance retrieved from ELB in previous block and populate ID/IP for each
  ec2_ids.each do |i|
    aws_id = ec2.describe_instances(options = {:instance_ids => ["#{i}"]})
    aws_id_resp = aws_id[:reservations].first[:instances].first[:private_ip_address]
    aws_id_id = aws_id[:reservations].first[:instances].first[:instance_id]
    aws_elb_resp = elb.describe_instance_health({load_balancer_name: "#{elbname}", instances:[{ instance_id: "#{i}"}]})
    response.reply("#{aws_id_id} - #{aws_id_resp} - ELB Health = " + aws_elb_resp.instance_states[0].state)
  end
  	

    end
end 
 Lita.register_handler(ELBIDD)

end
end
