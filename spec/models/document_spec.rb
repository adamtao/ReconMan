require 'rails_helper'

describe Document do
  before :all do
    @document = build_stubbed(:document)
  end

  it ".unique_file_number should return a string including the job id" do
    ufn = @document.unique_file_number

    expect(ufn).to be_instance_of(String)
    expect(ufn).to match @document.task.job.id.to_s
  end
end
