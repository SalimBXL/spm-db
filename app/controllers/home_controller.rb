class HomeController < ApplicationController

    def index
        @lasts = Spm.last(8).reverse
    end
    
end
