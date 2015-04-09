class AddSecondNoticeSentOnToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :second_notice_sent_on, :date
  end
end
