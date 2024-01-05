class EmployeesController < ApplicationController
  def index
    Employee.all
  end

  def new
  end

  def create
    employee_params = employee_params(params)
    @employee = Employee.new(employee_params)

    if @employee.save
      flash[:success] = 'Employee created successfully'
      redirect_to employees_path
    else
      flash.now[:error] = 'Error creating employee'
      render :new
    end
  end

  def modify
    @employee = Employee.find(params[:id])
  end

  def update
    @employee = Employee.find(params[:id])

    if @employee.update(employee_params(params))
      flash[:success] = 'Employee updated successfully'
      redirect_to employees_path
    else
      flash.now[:error] = 'Error updating employee'
      render :modify
    end
  end

  def destroy
    @employee = Employee.find(params[:id])

    @employee.destroy

    redirect_to employees_path
  end

  def employee_params(params)
    return {
      first_name: params[:first_name],
      last_name: params[:last_name],
      email: params[:email],
      phone_numbers: params[:phone_numbers],
      salary: params[:salary],
      date_of_joining: params[:date_of_joining]
    }
  end

end
