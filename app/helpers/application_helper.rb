module ApplicationHelper

    def depository
        deposit = "/home/pet/Database"
    end

    def spm_base_name_path(npp, date)
        formatted_date = format_date(date)
        File.join(study_path(npp, date), "SPM_classic.pdf")
    end

    def spm_mirror_name_path(npp, date)
        formatted_date = format_date(date)
        File.join(study_path(npp, date), "SPM_mirror.pdf")
    end

    def study_path(npp, date)
        formatted_date = format_date(date)
        File.join(depository, npp, formatted_date)
    end

    def patient_split_fullname(patient)
        split = patient.fullname.split("^")
        nom = "<strong>#{split[0].upcase}</strong> <em>#{split[1].titleize if split[1]}</em>"
        nom.html_safe
    end

    
    private

    def format_date(date)
        date.strftime("%Y%m%d")
    end
end
