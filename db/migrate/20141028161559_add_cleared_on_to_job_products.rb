class AddClearedOnToJobProducts < ActiveRecord::Migration
  def change
    add_column :job_products, :cleared_on, :date
    add_index :job_products, :cleared_on

    JobProduct.all.each do |jp|
      if jp.recorded_on.present?
        jp.update_column(:cleared_on, jp.updated_at.to_date)
      end
    end

  end
end
