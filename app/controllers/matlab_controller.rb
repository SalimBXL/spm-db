class MatlabController < ApplicationController
    before_action :get_camera, only: [:index, :start_matlab]
    before_action :get_config, only: [:get_zip_ok, :start_matlab_ok]

    #############
    #   INDEX   #
    #############
    def index
        @progression = get_progression(1, 13)
    end


    #########################
    #   READ DICOM HEADER   #
    #########################
    def read_dicom_header
        @progression = get_progression(2, 13)
        session[:camera] = params[:camera] if params[:camera]
    end

    def read_dicom_header_ok
        @progression = get_progression(3, 13)
        @res = false

        # liste patients
        patients = find_orthanc_patients
        if patients

            # dernier patient
            dernier_patient = find_orthanc_dernier_patient(patients[patients.length-1])
            patient_studies = dernier_patient["Studies"]
            dernier_patient = dernier_patient["MainDicomTags"]

            puts "***** CONTROLLER - dernier_patient : #{dernier_patient}"
            puts "***** CONTROLLER - patient_studies : #{patient_studies}"

            if dernier_patient

                # patient id
                patient_id = dernier_patient["PatientID"]
                patient_name = dernier_patient["PatientName"]
                
                puts "***** CONTROLLER - patient_id : #{patient_id}"
                puts "***** CONTROLLER - patient_name : #{patient_name}"
                puts "***** CONTROLLER - patient_studies : #{patient_studies}"

                if patient_id and patient_name and patient_studies
                    session[:patient_id] = patient_id
                    session[:patient_name] = patient_name

                    puts "***** CONTROLLER - session[:patient_id] : #{session[:patient_id]}"
                    puts "***** CONTROLLER - session[:patient_name] : #{session[:patient_name]}"

                    # last study
                    patient_study = patient_studies[patient_studies.length-1]
                    patient_study = find_orthanc_study(patient_study)
                    patient_study_date = patient_study["StudyDate"]
                    if patient_study_date
                        session[:study_date] = patient_study_date

                        puts "***** CONTROLLER - session[:study_date] : #{session[:study_date]}"

                        @res = true
                    end
                end
            end
        end
    end


    #################
    #   GET ZIP     #
    #################
    def get_zip
        @progression = get_progression(5, 13)
    end

    def get_zip_ok
        @progression = get_progression(6, 13)
        @res = false

        # liste patients
        patients = find_orthanc_patients
        if patients

            # dernier patient
            dernier_patient = find_orthanc_dernier_patient(patients[patients.length-1])
            if dernier_patient
                id = dernier_patient["ID"]
                patient_id = dernier_patient["MainDicomTags"]["PatientID"]
                chemin = File.join(@url, "patients", id, "media")
                download = File.join(@download_dir, "#{patient_id}.zip")
                comm = "curl #{chemin} --output #{download}; wait"
                @value = %x( #{@xterm} "#{comm}" )
                @wasGood2 = $?
                #@wasGood = system( "#{xterm} '#{comm}'" )
                # Check if zipfile is present
                zipfiles = File.join(@download_dir, "*.zip")
                zips = Dir.glob(zipfiles)
                @res = (zips.length == 1) ? true : false
                @error_message = (zips.length == 1) ? nil : "ZIP file not found in #{@download_dir}"
            end
        end
    end


    #####################
    #   START MATLAB    #
    #####################
    def start_matlab
        @progression = get_progression(7, 13)
    end

    def start_matlab_ok
        @progression = get_progression(8, 13)

        #generateing startup.m
        script = "test"
        script = @cam1_script if session[:camera] == "1"
        script = @cam2_script if session[:camera] == "2"
        File.open(@startup_matlab, "w") do |f|
            f.puts("cd #{@scripts_matlab}")
            f.puts(script)
            f.close
        end
        startup = Dir.glob(@startup_matlab)
        res = (startup.length == 1) ? true : false
        @error_message = (startup.length == 1) ? nil : "Startup file not found (#{@startup_matlab})"
        
        # Starting matlab
        if res
            comm = "#{@matlab} ; wait"
            #comm = "top ; wait"
            @value = %x( #{@xterm} "#{comm}" )
            @wasGood2 = $?
            @res = true
        end
    end


    #####################
    #   ADD PDF TO DB   #
    #####################
    def add_pdf_to_db
        @progression = get_progression(9, 13)
    end

    def add_pdf_to_db_ok
        @progression = get_progression(10, 13)
        xterm = "xterm -e"
        comm = "top ; wait"
        @value = %x( #{xterm} "#{comm}" )
    end


    #########################
    #   REMOVE DICOM ENTRY  #
    #########################
    def remove_dicom_entry
        @progression = get_progression(11, 13)
    end

    def remove_dicom_entry_ok
        @progression = get_progression(12, 13)
        xterm = "xterm -e"
        comm = "top ; wait"
        @value = %x( #{xterm} "#{comm}" )
    end


    #################
    #   FINISHED    #
    #################
    def finished
        @progression = get_progression(13, 13)
    end


    ################################################################################

    private

    def get_config
        # recupère depuis la config
        settings = Hash.new
        Setting.all.find_each do |setting|
            settings[setting[:key]] = setting[:value]
        end
        @url = settings['dicom_server_url']
        @xterm = settings['xterm']
        @download_dir = settings['download_directory']
        @matlab = settings['matlab']
        @startup_matlab = settings['startup_matlab']
        @scripts_matlab = settings['scripts_matlab']
        @cam1_script = settings['cam1_script']
        @cam2_script = settings['cam2_script']
    end

    def get_camera
        settings = Hash.new
        Setting.all.find_each do |setting|
            settings[setting[:key]] = setting[:value]
        end
        @cameras = Hash.new
        @cameras[1] = settings['cam1_nom']
        @cameras[2] = settings['cam2_nom']
        @camera = params[:camera] if params[:camera]
    end

    def get_progression(etape, etapes)
        (etape == etapes) ? 100 : ( (100 / (etapes) ) * (etape) )
    end

    ##### ORTHANC #####

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
        end
        JSON.parse(response.body)
    end

    def find_orthanc_patients
        request_api("http://127.0.0.1:8042/patients")
    end

    def find_orthanc_dernier_patient(id)
        request_api(File.join("http://127.0.0.1:8042/patients", id))
    end

    def find_orthanc_study(id)
        request_api(File.join("http://127.0.0.1:8042/studies", id))
    end

end
