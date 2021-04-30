class HomeController < ApplicationController

    def index
        @lasts = Spm.last(8).reverse

        # Local server and client IP addresses
        @admin_mode = false
        client_address = request.remote_ip
        ips = Socket.ip_address_list
        ips.each do |ip|
            admin_mode = true if ip.ip_address == server_address
        end
    end
    
end
