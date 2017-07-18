require 'rails_helper'

RSpec.describe DocumentTemplate, type: :model do

  before :all do
    @document_template = FactoryGirl.create(:document_template)
  end

  subject { @document_template }

  it { should respond_to :doctype }
end
