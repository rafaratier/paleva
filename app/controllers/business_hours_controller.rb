class BusinessHoursController < ApplicationController
  before_action :set_establishment, only: [ :index ]

  skip_before_action :require_registration_steps, only: [ :index, :edit, :update ]

  def index
    @business_hours = @establishment.business_hours
  end

  def edit
    @business_hour = BusinessHour.find(params[:id])
    @establishment = @business_hour.establishment
  end

  def update
    @establishment = Establishment.find(params[:id])
    business_hour_id = params[:format].to_i
    @business_hour = @establishment.business_hours.find { |bh| bh.id == business_hour_id }

    if @business_hour.update(business_hour_params)
      redirect_to establishment_business_hours_path(@establishment.id), notice: "Horário atualizado com sucesso"
    else
      flash.now[:alert] =  @business_hour.errors.full_messages.join(", ")
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
