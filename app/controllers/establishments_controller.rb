class EstablishmentsController < ApplicationController
  def new
    @establishment = Establishment.new
    @establishment.build_address
  end

  def create
    @establishment = Establishment.new(
      establishment_params
    )

    @establishment.owner = User.find_by(name: current_user.name)

    if @establishment.save
      redirect_to new_establishment_business_hour_path(@establishment.id), notice: t("notices.establishment_created")
    else
      flash.now[:alert] =  @establishment.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  private

  def establishment_params
    params.require(:establishment).permit(
      :trade_name,
      :legal_name,
      :business_national_id,
      :email,
      :phone,
      address_attributes: [
        :street_name,
        :street_number,
        :neighborhood,
        :city,
        :state,
        :country
      ]
    )
  end
end
