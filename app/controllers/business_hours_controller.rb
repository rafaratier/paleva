# app/controllers/business_hours_controller.rb
class BusinessHoursController < ApplicationController
  before_action :set_establishment

  def index
  end

  def new
    @business_hour = @establishment.business_hours.build
  end

  private

  def set_establishment
    @establishment = Establishment.find(params[:format])
  end

  def business_hour_params
    params.require(:business_hour).permit(:day_of_week, :is_open, :open_time, :close_time)
  end
end
