class AddFirstNoticeSentOnToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :first_notice_sent_on, :date
  end
end
