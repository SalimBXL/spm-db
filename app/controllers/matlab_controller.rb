class MatlabController < ApplicationController
    before_action :get_camera, only: [:index, :start_matlab]
    before_action :get_config, only: [:get_zip_ok, :start_matlab_ok, :add_pdf_to_db_ok, :remove_dicom_entry_ok]

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

            if dernier_patient

                # patient id
                patient_id = dernier_patient["PatientID"]
                patient_name = dernier_patient["PatientName"]

                if patient_id and patient_name and patient_studies
                    session[:patient_id] = patient_id
                    session[:patient_name] = patient_name

                    # last study
                    patient_study = patient_studies[patient_studies.length-1]
                    patient_study = find_orthanc_study(patient_study)
                    patient_study = patient_study["MainDicomTags"]
                    patient_study_date = patient_study["StudyDate"]
                    if patient_study_date
                        session[:study_date] = patient_study_date
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
        @res = false

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
        @res = false
        
        # ajouter patient
        patients = Patient.where(npp: session[:patient_id])
        if patients.size < 1
            patient = Patient.create(fullname: session[:patient_name], npp: session[:patient_id])
            if patient.save
                # ok
                indice_patient = patient.id
            else
                @error_message = "Impossible to create patient."
            end
        else
            indice_patient = patients.first.id
        end

        # ajouter spm
        spm = Spm.where(patient_id: session[:patient_id], study_date: session[:study_date])
        if spm.size < 1

            # check si pdfs existent
            dir = File.join(@depository, session[:patient_id], session[:study_date])
            spms = Dir.glob(File.join(dir, "*.pdf"))
            @error_message = (spms.length == 2) ? nil : "PDF files not found in #{dir}"

            # save 
            if (spms.length == 2)
                base = File.join(@depository, session[:patient_id], session[:study_date], @file_spm_base)
                mirror = File.join(@depository, session[:patient_id], session[:study_date], @file_spm_mirror)

                s = Spm.create(patient_id: indice_patient, study_date: session[:study_date], spm_base: base, spm_mirror: mirror)

                if s.save
                    # ok
                    @res = true
                else
                    @error_message = "Error while saving SPM into database."
                    if s.errors.any?
                        s.errors.full_messages.each do |message|
                            puts "===>>>> #{message}"
                        end
                    end
                end
            else
                @error_message = "Wrong number of PDF files in #{dir}."
            end
        else
            @error_message = "Another SPM already exists in the Database."
        end
    end


    #########################
    #   REMOVE DICOM ENTRY  #
    #########################
    def remove_dicom_entry
        @progression = get_progression(11, 13)
    end

    def remove_dicom_entry_ok
        @progression = get_progression(12, 13)
        File.open(@startup_matlab, "w") do |f|
            f.puts("")
            f.close
        end
        startup = Dir.glob(@startup_matlab)
        res = (startup.length == 1) ? true : false
        @error_message = (startup.length == 1) ? nil : "Startup file not found (#{@startup_matlab})"
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
        @depository = settings['depository']
        @file_spm_base = settings['file_spm_base']
        @file_spm_mirror = settings['file_spm_mirror']
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
        #puts "***** CONTROLLER - request_api : #{url}"
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
