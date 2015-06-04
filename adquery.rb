require 'net/ldap'

ldap = Net::LDAP.new :host => "172.21.xxx.xxx",
     :port => 389,
     :auth => {
           :method => :simple,
           :username => "user@domain.fqdn.com",
           :password => 'xxxxxxx'
     }

filter = Net::LDAP::Filter.eq( "sAMAccountName", "domainusername" )
treebase = "dc=domain, dc=fqdn ,dc=com"

ldap.search( :base => treebase, :filter => filter, :attributes => "lockoutTime") do |entry|

    puts "DN: #{entry.dn}"
    entry.each do |attribute, values|
    puts "   #{attribute}:"
    values.each do |value|
    puts "      --->#{value}"
     end
    end

end
p ldap.get_operation_result

