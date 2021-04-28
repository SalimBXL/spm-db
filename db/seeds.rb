# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


settings = Setting.create([
    {key: 'depository', value: '/home/pet/database'}, 
    {key: 'file_spm_base', value: 'SPM_basic.pdf'}, 
    {key: 'file_spm_mirror', value: 'SPM_mirror.pdf'}, 
    {key: 'xterm', value: 'xterm -e'},
    {key: 'download_directory', value: '/home/pet/Downloads'},
    {key: 'dicom_server_url', value: '127.0.0.1:8042'},
    {key: 'matlab', value: 'matlab'},
    {key: 'scripts_matlab', value: '/home/pet/spm/scripts_matlab'},
    {key: 'startup_matlab', value: '/home/pet/Documents/MATLAB/startup.m'},
    {key: 'cam1_nom', value: 'PET-CT'},
    {key: 'cam1_script', value: 'all_petct'},
    {key: 'cam2_nom', value: 'PET-MR'},
    {key: 'cam2_script', value: 'all_petmr'}
])

patients = Patient.create([
    {fullname: 'Bruce Wayne', npp: '700101MW01'},
    {fullname: 'Tony Startk', npp: '710203MS02'},
    {fullname: 'Peter Parker', npp: '720304MP01'},
    {fullname: 'Natasha Romanoff', npp: '730510FR05'}
])

spms = Spm.create([
    {study_date: '20210202', patient_id: patients.last.id, spm_base: '/home/pet/database/spm_basic.pdf'},
    {study_date: '20210205', patient_id: patients.last.id, spm_base: '/home/pet/database/spm_basic.pdf'},
    {study_date: '20210406', patient_id: patients.first.id, spm_base: '/home/pet/database/spm_basic.pdf'},
    {study_date: '20210307', patient_id: patients.first.id, spm_base: '/home/pet/database/spm_basic.pdf'},
    {study_date: '20210208', patient_id: patients.first.id, spm_base: '/home/pet/database/spm_basic.pdf'},
    {study_date: '20210208', patient_id: patients.last.id, spm_base: '/home/pet/database/spm_basic.pdf'},
    {study_date: '20210209', patient_id: patients.last.id, spm_base: '/home/pet/database/spm_basic.pdf'}
])
