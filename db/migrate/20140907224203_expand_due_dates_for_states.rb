class ExpandDueDatesForStates < ActiveRecord::Migration
  def change
  	add_column :states, :time_to_notify_days, :integer, default: 30
  	add_column :states, :time_to_dispute_days, :integer, default: 30
  	rename_column :states, :due_within_days, :time_to_record_days
  	add_column :states, :can_force_reconveyance, :boolean, default: true
  	add_column :states, :allow_sub_of_trustee, :boolean, default: false
  	add_column :states, :record_reconveyance_request, :boolean, default: false

  	Job.all.each do |j|
  		j.deed_of_trust_number = j.parcel_number
  		j.save
  	end
  end
end
