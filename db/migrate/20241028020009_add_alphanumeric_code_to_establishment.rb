class AddAlphanumericCodeToEstablishment < ActiveRecord::Migration[7.2]
  def change
    add_column :establishments, :code, :string
  end
end
