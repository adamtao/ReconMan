class DocumentTemplate < ApplicationRecord

	include Ownable
  validates :doctype, :layout, :content, presence: true

  def self.layout_options
    [["Letterhead", "letterhead"], ["Main Application", "application"]]
  end

  def name
    self.doctype.titleize
  end
end
