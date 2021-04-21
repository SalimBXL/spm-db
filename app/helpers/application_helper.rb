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

    private

    def format_date(date)
        date.strftime("%Y%m%d")
    end
end
