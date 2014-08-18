class AddStatusToStates < ActiveRecord::Migration
  def change
    add_column :states, :active, :boolean, default: false
    State.where(abbreviation: %w(AZ CA CO ID MT NB ND NM NV OK OR SD TX UT WA WY)).update_all(active: true)
  end
end
