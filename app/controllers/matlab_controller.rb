class MatlabController < ApplicationController
    before_action :get_camera, only: [:index, :start_matlab]

    def index
        @progression = get_progression(1, 13)
    end

    def get_zip
        @progression = get_progression(3, 13)
    end

    def get_zip_ok
        @progression = get_progression(4, 13)
        xterm = "xterm -e"
        comm = "top ; wait"
        @value = %x( #{xterm} "#{comm}" )
    end

    def read_dicom_header
        @progression = get_progression(5, 13)
    end

    def read_dicom_header_ok
        @progression = get_progression(6, 13)
        xterm = "xterm -e"
        comm = "top ; wait"
        @value = %x( #{xterm} "#{comm}" )
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
    
end
