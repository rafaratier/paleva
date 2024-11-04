class EstablishmentsController < ApplicationController
  skip_before_action :require_registration_steps, only: [ :new, :create ]

  def index
  end

  def new
    @establishment = Establishment.new
    @establishment.build_address
  end

  def create
    @establishment = Establishment.new(
      establishment_params
    )

    @establishment.owner = User.find_by(personal_national_id: current_user.personal_national_id)

    if @establishment.save
      redirect_to establishment_business_hours_path(@establishment.id),
      notice: t("notices.establishment_created")
    else
      flash.now[:alert] =  @establishment.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end

    def show
    end

    def edit
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
