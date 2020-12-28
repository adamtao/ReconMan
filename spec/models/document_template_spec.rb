require 'rails_helper'

RSpec.describe DocumentTemplate, type: :model do

  before :all do
    @document_template = create(:document_template)
  end

  subject { @document_template }

  it { should respond_to :doctype }
end
