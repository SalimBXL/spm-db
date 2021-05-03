class SpmsController < ApplicationController
    before_action :find_spm, only: [:show, :edit, :update, :destroy]
    before_action :find_patients, only: [:new, :edit]

    def index
        if params[:patient_id]
            @patient = Patient.find(params[:patient_id])
            @spms = Spm.where(patient_id: @patient.id).order(:created_at).page(params[:page]) if @patient
        else            
            @spms = Spm.order(:study_date).reverse_order.page(params[:page])
        end

        
        # Local server and client IP addresses
        @admin_mode = false
        client_address = request.remote_ip
        ips = Socket.ip_address_list
        ips.each do |ip|
            @admin_mode = true if ip.ip_address == client_address
        end

    end

    def new
        @spm = Spm.new
    end

    def show
    end

    def create
        @spm = Spm.create(spm_params)
        if @spm.save
            flash[:notice] = "SPM created"
            redirect_to spms_path
        else
            flash[:alert] = "Error(s)"
            render :new
        end
        
    end

    def edit
    end

    def update
        if @spm.update(spm_params)
            flash[:notice] = "SPM updated."
            redirect_to spms_path
        else
            render :edit
        end
    end

    def destroy
        @spm.destroy
    end

    private

    def spm_params
        params.require(:spm).permit(:patient_id, :study_date, :spm_base, :spm_mirror)
    end

    def find_spm
        @spm = Spm.find(params[:id])
    end

    def find_patients
        @patients = Patient.order(:fullname)
    end

end
