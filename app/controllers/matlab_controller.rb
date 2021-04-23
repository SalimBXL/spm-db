class MatlabController < ApplicationController
    before_action :get_camera, only: [:index, :start_matlab]

    def index
        @progression = get_progression(1, 6)
    end

    def get_zip
        @progression = get_progression(2, 6)
    end

    def get_zip_ok
        @progression = get_progression(3, 6)
        xterm = "xterm -e"
        comm = "top ; wait"
        @value = %x( #{xterm} "#{comm}" )
    end

    def read_dicom_header
        @progression = get_progression(4, 6)
    end

    def read_dicom_header_ok
        @progression = get_progression(5, 6)
        xterm = "xterm -e"
        comm = "top ; wait"
        @value = %x( #{xterm} "#{comm}" )
    end

    def start_matlab
        @progression = get_progression(6, 6)

        xterm = "xterm -e"
        comm = "top ; wait"

        @value = %x( #{xterm} "#{comm}" )
        @wasGood = system( "#{xterm} '#{comm}'" )
        @wasGood2 = $?
    end

    def add_pdf_to_db
        @progression = get_progression(5, 6)
    end

    def remove_dicom_entry
        @progression = get_progression(6, 6)
    end

    private

    def get_camera
        @cameras = Hash.new
        @cameras[1] = "PET-CT"
        @cameras[2] = "PET-MR"
        @camera = params[:camera] if params[:camera]
    end

    def get_progression(etape, etapes)
        ( (100/etapes) * (etape-1) )
    end
    
end
