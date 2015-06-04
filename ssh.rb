module Lita
  module Handlers
    class SshRun < Handler
      require 'net/ssh'
      
      route(/^run\s+(.+)\s+on\s+(.+)/i, :run_ssh, command: true, restrict_to: :sysops)

      def run_ssh(response)

        cmd = response.matches[0][0]
        server = response.matches[0][1]

        if server && cmd
          Net::SSH.start(server, 'username', :keys => "./source/id_rsa", :timeout => 10) do |ssh|
            output = ssh.exec!(cmd)
            if !output
              response.reply("Command was run, but it appears there was no output to stdout or stderr.")
            else
              response.reply("#{server}> " + output.encode('utf-8', :invalid => :replace, :undef => :replace, :replace => '_') + "#{server} -EOM- ")
            end
          end
        end
      end

    end

    Lita.register_handler(SshRun)
  end
end
