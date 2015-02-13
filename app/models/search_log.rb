class SearchLog < ActiveRecord::Base
  belongs_to :task
  belongs_to :user

  validates :user, presence: true
  validates :task, presence: true
  validates :status, presence: true

end
