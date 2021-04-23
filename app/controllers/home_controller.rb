class HomeController < ApplicationController

    def index
        @lasts = Spm.last(5)
    end
    
end
