class Document < ApplicationRecord
  belongs_to :task
  has_attached_file :file,
    url: '/system/jobs/:file_number/documents/:basename.:extension',
    path: "#{ENV['PAPERCLIP_PATH']}jobs/:file_number/documents/:basename.:extension",
    s3_credentials: Rails.root.join("config", "s3.yml"),
    storage: ENV['PAPERCLIP_STORAGE'].to_sym

  validates :task, presence: true
  validates :file, presence: true

  do_not_validate_attachment_file_type :file

  # For URL generation in paperclip
  def unique_file_number
    "#{self.task.job.link_name.parameterize}-#{self.task.job.id}"
  end
end
