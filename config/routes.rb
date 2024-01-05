Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  get '/employees', to: 'employees#index'
  get '/employees/new', to: 'employees#new'
  post '/employees', to: 'employees#create'
  get '/employees/:id/modify', to: 'employees#modify', as: :modify_employee
  patch '/employees/:id', to: 'employees#update', as: :update_employee
  delete '/employees/:id', to: 'employees#destroy',as: :delete_employee
  get '/employees/tax_details', to: 'employees#employees_tax_deduction'
  get '/employee/:id/tax_detail', to: 'employees#get_employee_tax_detuction'


  root "employees#index"
end
