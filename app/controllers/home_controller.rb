class HomeController < ApplicationController

    def index
        @lasts = Spm.last(8).reverse

        # Local server IP address
        ip = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
        @client_address = ip.ip_address

        # Client IP address
        @server_address = request.remote_ip
    end
    
end
