Rails.application.routes.draw do
  get "/", to: "home#index"
  root "home#index"

  get "/matlab", to: "matlab#index"

  get "/get_zip", to: "matlab#get_zip"
  get "/get_zip_ok", to: "matlab#get_zip_ok"

  get "/read_dicom_header", to: "matlab#read_dicom_header"
  get "/read_dicom_header_ok", to: "matlab#read_dicom_header_ok"

  get "/start_matlab", to: "matlab#start_matlab"
  get "/start_matlab_ok", to: "matlab#start_matlab_ok"

  get "/add_pdf_to_db", to: "matlab#add_pdf_to_db"
  get "/add_pdf_to_db_ok", to: "matlab#add_pdf_to_db_ok"

  get "/remove_dicom_entry", to: "matlab#remove_dicom_entry"
  get "/remove_dicom_entry_ok", to: "matlab#remove_dicom_entry_ok"

  get "/finished", to: "matlab#finished"
  

  resources :spms
  resources :patients
  resources :settings

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
