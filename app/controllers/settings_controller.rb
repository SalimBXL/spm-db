class SettingsController < ApplicationController
    before_action :find_setting, only: [:show, :edit, :update, :destroy]

    def index
        @settings = Setting.order(:key).page(params[:page])
    end

    def show
    end

    def new
        @setting = Setting.new
    end

    def create
        @setting = Setting.create(setting_params)
        if @setting.save
            flash[:notice] = "Settings created"
            redirect_to settings_path
        else
            flash[:alert] = "Error(s)"
            render :new
        end
    end

    def edit
    end

    def update
        if @setting.update(setting_params)
            flash[:notice] = "Settings updated."
            redirect_to settings_path
        else
            render :edit
        end
    end

    def destroy
        @setting.destroy
    end

    private

    def setting_params
        params.require(:setting).permit(:key, :value)
    end

    def find_setting
        @setting = Setting.find(params[:id])
    end
    
end
