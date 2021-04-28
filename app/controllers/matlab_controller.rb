class MatlabController < ApplicationController
    before_action :get_camera, only: [:index, :start_matlab]

    def index
        @progression = get_progression(1, 13)
    end

    def read_dicom_header
        @progression = get_progression(2, 13)
    end

    def read_dicom_header_ok
        @progression = get_progression(3, 13)
        @res = false
        # liste patients
        patients = find_orthanc_patients
        if patients
            # dernier patient
            dernier_patient = find_orthanc_dernier_patient(patients[patients.length-1])
            if dernier_patient
                # patient id
                patient_id = nil
                if patient_id
                    @res = true
                end
            end
        end
    end

    def get_zip
        @progression = get_progression(5, 13)
    end

    def get_zip_ok
        @progression = get_progression(6, 13)
        

        # Check if zipfile is present
        working_dir = "/home/salim/Téléchargements/"
        zipfiles = File.join(working_dir, "*.zip")
        zips = Dir.glob(zipfiles)
        #@res = (zips.length == 1) ? true : false
    end

    def start_matlab
        @progression = get_progression(7, 13)
    end

    def start_matlab_ok
        @progression = get_progression(8, 13)
        xterm = "xterm -e"
        comm = "top ; wait"
        @value = %x( #{xterm} "#{comm}" )
        #@wasGood = system( "#{xterm} '#{comm}'" )
        #@wasGood2 = $?
    end

    def add_pdf_to_db
        @progression = get_progression(9, 13)
    end

    def add_pdf_to_db_ok
        @progression = get_progression(10, 13)
        xterm = "xterm -e"
        comm = "top ; wait"
        @value = %x( #{xterm} "#{comm}" )
    end

    def remove_dicom_entry
        @progression = get_progression(11, 13)
    end

    def remove_dicom_entry_ok
        @progression = get_progression(12, 13)
        xterm = "xterm -e"
        comm = "top ; wait"
        @value = %x( #{xterm} "#{comm}" )
    end

    def finished
        @progression = get_progression(13, 13)
    end


    private

    def get_camera
        @cameras = Hash.new
        @cameras[1] = "PET-CT"
        @cameras[2] = "PET-MR"
        @camera = params[:camera] if params[:camera]
    end

    def get_progression(etape, etapes)
        (etape == etapes) ? 100 : ( (100 / (etapes) ) * (etape) )
    end

    def request_api(url)
        begin
            response = Excon.get(url)
        rescue => e
            @error_message = "#{url} => #{e}"
            return nil
        end
        if response.status != 200
            @error_message = "Response status : #{response.status}"
            return nil
        else 
            JSON.parse(response.body)
        end
    end

    def find_orthanc_patients
        request_api("http://127.0.0.1:8042/patients")
    end

    def find_orthanc_dernier_patient(id)
        request_api(File.join("http://127.0.0.1:8042/patients", id))
    end

end
