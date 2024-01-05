class EmployeesController < ApplicationController
  def index
    @employees = Employee.all
    render json: @employees
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

  def employees_tax_deduction
    current_date = Date.today
    financial_year_start = current_date.month >= 4 ? Date.new(current_date.year, 4, 1) : Date.new(current_date.year - 1, 4, 1)
    financial_year_end = financial_year_start + 1.year - 1.day

    employees = Employee.where('date_of_joining <= ?', financial_year_end)
    tax_details = []

    employees.to_a.each do |employee|
      yearly_salary = calculate_yearly_salary(employee, financial_year_start, financial_year_end)
      tax_amount = calculate_tax(yearly_salary)
      cess_amount = calculate_cess(yearly_salary)
      actual_salary = yearly_salary - (tax_amount + cess_amount)

      tax_details << {
        employee_id: employee.employee_id,
        first_name: employee.first_name,
        last_name: employee.last_name,
        yearly_salary: yearly_salary,
        tax_amount: tax_amount,
        cess_amount: cess_amount,
        actual_yearly_salary: actual_salary
      }
    end

    render json: { tax_details: tax_details }, status: :ok
  end

  def get_employee_tax_detuction
    current_date = Date.today
    financial_year_start = current_date.month >= 4 ? Date.new(current_date.year, 4, 1) : Date.new(current_date.year - 1, 4, 1)
    financial_year_end = financial_year_start + 1.year - 1.day

    employee = Employee.find(params[:id])

    if employee.blank?
      flash.now[:error] = 'Employee does not exist'
      redirect_to employees_path
    end

    yearly_salary = calculate_yearly_salary(employee, financial_year_start, financial_year_end)
    tax_amount = calculate_tax(yearly_salary)
    cess_amount = calculate_cess(yearly_salary)
    actual_salary = yearly_salary - (tax_amount + cess_amount)


    tax_details = {
      employee_id: employee.employee_id,
      first_name: employee.first_name,
      last_name: employee.last_name,
      yearly_salary: yearly_salary,
      tax_amount: tax_amount,
      cess_amount: cess_amount,
      actual_yearly_salary: actual_salary

    }

    render json: { tax_details: tax_details }, status: :ok
  end

  private

  def calculate_yearly_salary(employee, start_date, end_date)
    total_salary = 0.0

    while start_date <= end_date
      if start_date >= employee.date_of_joining
        total_days_in_month = Date.new(start_date.year, start_date.month, -1).day

        if start_date.month == employee.date_of_joining.month && start_date.year == employee.date_of_joining.year
          days_worked_in_month = total_days_in_month - (employee.date_of_joining.day - 1)
        elsif start_date.month == (employee.date_of_joining.month % 12) + 1 && start_date.year == employee.date_of_joining.year
          days_worked_in_month = [employee.date_of_joining.day - 1, total_days_in_month].min
        else
          days_worked_in_month = total_days_in_month
        end

        total_salary += (employee.salary / total_days_in_month.to_f) * days_worked_in_month
      end

      start_date += 1.month
    end

    total_salary
  end


  def calculate_tax(yearly_salary)
    case yearly_salary
    when 0..250000
      0
    when 250001..500000
      (yearly_salary - 250000) * 0.05
    when 500001..1000000
      250000 * 0.05 + (yearly_salary - 500000) * 0.1
    else
      250000 * 0.05 + 500000 * 0.1 + (yearly_salary - 1000000) * 0.2
    end
  end

  def calculate_cess(yearly_salary)
    cess_rate = 0.02
    additional_cess_amount = [yearly_salary - 2500000, 0].max * cess_rate
    additional_cess_amount
  end
end
