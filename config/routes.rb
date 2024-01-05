Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  get '/employees', to: 'employees#index'
  get '/employees/new', to: 'employees#new'
  post '/employees', to: 'employees#create'
  get '/employees/:id/modify', to: 'employees#modify', as: :modify_employee
  patch '/employees/:id', to: 'employees#update', as: :update_employee
  delete '/employees/:id', to: 'employees#destroy',as: :delete_employee

   root "employees#index"
end
