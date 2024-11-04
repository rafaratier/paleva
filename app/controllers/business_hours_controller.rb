class BusinessHoursController < ApplicationController
  before_action :set_establishment, only: [ :index, :update ]

  skip_before_action :require_registration_steps, only: [ :index, :edit, :update ]

  def index
    @business_hours = @establishment.business_hours
  end

  def edit
    @establishment = Establishment.find(params[:id])
    @business_hour = BusinessHour.find(params[:id])
  end

  def update
    @business_hour = BusinessHour.find(params[:id])

    if @business_hour.update(business_hour_params)
      redirect_to establishment_business_hours_path(@establishment.id), notice: "HORARIO ATUALIZADO COM SUCESSO"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_establishment
    @establishment = Establishment.find(params[:format])
  end

  def business_hour_params
    params.require(:business_hour).permit(:day_of_week, :status, :open_time, :close_time)
  end
end
