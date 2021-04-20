class MatlabController < ApplicationController
    before_action :get_camera, only: [:index, :start_matlab]

    def index        
    end

    def start_matlab

    end

    private

    def get_camera
        @camera = params[:camera] if params[:camera]
    end
    
end
