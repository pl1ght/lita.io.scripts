elb = Aws::ElasticLoadBalancing::Client.new(credentials: credentials, region: 'us-east-1')

# Describe ELB specified                                                                                                                                                                                            
gadfly = elb.describe_load_balancers(options = {:load_balancer_names => ["Gadfly-mgr"]})

# Grab every instance behind an ELB                                                                                                                                                                                 
gadfly[:load_balancer_descriptions].first[:instances].each do |instance|
   ec2_ids << instance.instance_id
end

# Create EC2 Client                                                                                                                                                                                                 
ec2 = Aws::EC2::Client.new(credentials: credentials, region: 'us-east-1')

# Grab private IP address from each instance retrieved from ELB in previous block                                                                                                                                   
  ec2_ids.each do |i|
    aws_id = ec2.describe_instances(options = {:instance_ids => ["#{i}"]})
    aws_id_resp = aws_id[:reservations].first[:instances].first[:private_ip_address]
    url = "http://#{aws_id_resp}/gadfly-manager/instances.php"
    curl = Curl::Easy.new(url)
    curl.perform
    config = JSON.parse(curl.body_str)

    if config.empty?
      puts "null"
    else
      tens = config["10"]
      fives = config["5"]
      zeros = config["0"]
    end
      if tens
        ten = "#{tens.count}"
      else
        ten = "0"
      end

      if fives
        five = "#{fives.count}"
      else
        five = "0"
      end

      if zeros
        zero =  "#{zeros.count}"
      else
      
      zero =  "0"
      
      end
        response.reply("#{aws_id_resp}:\nPriority 10: #{ten} workers.\n Priority 5: #{five} workers.\n Priority 0: #{zero} workers.")
    end
