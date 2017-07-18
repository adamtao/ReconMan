class AddOwnableToDocumentTemplates < ActiveRecord::Migration[5.1]
  def change
    add_column :document_templates, :created_by_id, :integer
    add_column :document_templates, :modified_by_id, :integer
  end
end
