 module Lita
  module Handlers
  class EC2LIST < Handler
  require 'aws-sdk'                                                                                                                                                                                                  

  route(/^ec2 list\s+(.+)\s+(.+)/i, :ec2list, command: true, restrict_to: :sysops, help: {"ec2 list account region " => "list all ec2 instance states for given account and region"})
  
  def ec2list(response)
    profile = response.matches[0][0]
    region = response.matches[0][1]
    credentials = Aws::SharedCredentials.new(profile_name: profile.downcase)
    client = Aws::EC2::Client.new(credentials: credentials, region: region.downcase) 

  resp = client.describe_instances

  resp.reservations.each do |res|
    res.instances.each do |inst|
      iid = inst[:instance_id]
      istate = inst[:state].name
    # Check for instances with no Tags
      if inst.tags.nil?
        itag = "!!!NO TAG!!!"
	else
	  itag = inst.tags[0].value
end
    response.reply("#{itag} - #{iid} - #{istate}") 
	puts "#{itag} - #{iid} - #{istate}"  
end
  	
end
end 
 Lita.register_handler(EC2LIST)

end
end
end
