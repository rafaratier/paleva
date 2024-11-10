class EmployeesController < ApplicationController
  before_action :set_establishment

  def index
    @pending_employees = @establishment.pending_employees
  end

  def new
    @pending_employee = @establishment.pending_employees.build
  end

  def create
    @pending_employee = @establishment.pending_employees.build(employees_params)

    if @pending_employee.save
      redirect_to establishment_employees_path(@establishment),
      notice: t("notices.permission_registered")
    else
      flash.now[:alert] =  @pending_employee.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_establishment
    @establishment = Establishment.find(params[:format])
  end

  def employees_params
    params.require(:pending_employee).permit(:email, :personal_national_id)
  end
end
