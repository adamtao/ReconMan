require 'rails_helper'

RSpec.describe Lender, :type => :model do

  before do
    @lender = FactoryGirl.build_stubbed(:lender)
  end

  subject{@lender}

  it { should respond_to(:tracking_jobs) }

end
