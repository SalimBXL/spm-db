class PatientsController < ApplicationController
    before_action :find_patient, only: [:show, :edit, :update, :destroy]

    def index
        @patients = Patient.order(:fullname).page(params[:page])

        # Local server and client IP addresses
        @admin_mode = false
        client_address = request.remote_ip
        ips = Socket.ip_address_list
        ips.each do |ip|
            @admin_mode = true if ip.ip_address == client_address
        end
        
    end

    def show
    end

    def new
        @patient = Patient.new
    end

    def create
        @patient = Patient.create(patient_params)
        if @patient.save
            flash[:notice] = "Patient created"
            redirect_to patients_path
        else
            flash[:alert] = "Error(s)"
            render :new
        end
    end

    def edit
    end

    def update
        if @patient.update(patient_params)
            flash[:notice] = "Patient updated."
            redirect_to patients_path
        else
            render :edit
        end
    end

    def destroy
        @patient.destroy
    end

    private

    def patient_params
        params.require(:patient).permit(:fullname, :npp)
    end

    def find_patient
        @patient = Patient.find(params[:id])
    end
    
end
