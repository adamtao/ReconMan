class CreateDocumentTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :document_templates do |t|
      t.string :doctype
      t.string :layout
      t.text :content

      t.timestamps
    end
  end
end
