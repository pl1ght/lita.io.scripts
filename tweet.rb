require 'twitter'

 module Lita
  module Handlers
  class TWEET < Handler

  route(/^tweet\s+(.+)/i, :tweet, command: true, restrict_to: :sysops)  
  
    def tweet(response)
        
        client = Twitter::REST::Client.new do |config|
        config.consumer_key        = "XXXXXXXXXXXXXXXXXX"
        config.consumer_secret     = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        config.access_token        = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        config.access_token_secret = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        end
       
       tweeting = response.matches[0][0]
       client.update("#{tweeting}")
       
       response.reply("Tweeting " + "#{tweeting}")
       
    end
       

  Lita.register_handler(TWEET)

end
end
end
