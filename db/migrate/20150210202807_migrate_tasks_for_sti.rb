class MigrateTasksForSti < ActiveRecord::Migration
  def change
    Task.all.each do |task|
      if task.job.present? && task.job.job_type.present?
        task.update_column(:type, "#{task.job.job_type.to_s.ucfirst}Task")
      else
        task.update_column(:type, "TrackingTask")
      end
    end
  end
end
