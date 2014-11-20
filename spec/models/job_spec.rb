require 'rails_helper'

describe Job do

	before(:all) do
		Product.delete_all
		@tracking_product = create(:tracking_product)
		@search_product   = create(:search_product)
		@special_product  = create(:special_product)
	end

	describe "general functions" do
	  before(:each) {	@job = build(:job, job_products_attributes: build(:job_product).attributes) }

	  subject { @job }
	  it { should respond_to(:dashboard_product) }
	  it { should respond_to(:link_name) }
	  it { should respond_to(:deed_or_parcel_number) }
	  it { should respond_to(:total_price_cents) }

	  it "#mark_complete! should record the completion date" do
	  	@job.save!

	  	@job.mark_complete!

	  	expect(@job.completed_at).not_to be nil
	  	expect(@job.current_state).to eq("complete")
	  end

    it ".job_products_complete_between should return job products collection" do
      @job.save!
      jp = @job.job_products.first
      jp.mark_complete!

      jpcb = @job.job_products_complete_between(2.days.ago, 2.days.from_now)
      expect(jpcb).to include(jp)
    end

	  it '#re_open should open a closed job' do
	  	@job.save!
	  	@job.mark_complete!

	  	@job.re_open!

	  	expect(@job.completed_at).to be nil
	  	expect(@job.current_state).to eq("new")
	  end

	  it ".dashboard_jobs should include job" do
	  	@job.save!

	  	expect(Job.dashboard_jobs(user: create(:user), complete: false)).to include(@job)
	  end

	  it "should have open job_products (tasks)" do
	  	@job.save!

	  	expect(@job.open_products.length).to be > 0
	  	expect(@job.open_products.first).to be_instance_of(JobProduct)
	  end
	end

  describe "tracking job_type" do
  	before(:all) { @job = build_stubbed(:tracking_job) }

  	it "should initialize with a tracking job_product" do
  		expect(@job.default_products).to include(@tracking_product)
  		expect(@job.default_product_id).to eq(@tracking_product.id)
  	end

	  it "#dashboard_product should return one job_product (task)" do
	  	setup_job_with_job_products(@job)

	  	expect(@job.dashboard_product).to be_instance_of(JobProduct)
	  	expect(@job.dashboard_product.product).to eq(@tracking_product)
	  end
  end

  describe "search job_type" do
  	before(:all) { @job = build_stubbed(:search_job)	}

  	it "should initialize with a search job_product" do
  		expect(@job.default_products).to include(@search_product)
  		expect(@job.default_product_id).to eq(@search_product.id)
  	end

	  it "#dashboard_product should return one job_product (task)" do
	  	setup_job_with_job_products(@job)

	  	expect(@job.dashboard_product).to be_instance_of(JobProduct)
	  	expect(@job.dashboard_product.product).to eq(@search_product)
	  end
  end

  describe "special job_type" do
  	before(:all) { @job = build_stubbed(:special_job)	}

  	it "should initialize with a special job_product" do
  		expect(@job.default_products).to include(@special_product)
  		expect(@job.default_product_id).to eq(@special_product.id)
  	end

	  it "#dashboard_product should return one job_product (task)" do
	  	setup_job_with_job_products(@job)

	  	expect(@job.dashboard_product).to be_instance_of(JobProduct)
	  	expect(@job.dashboard_product.product).to eq(@special_product)
	  end
  end

  def setup_job_with_job_products(job)
  	job.initialize_job_products
  	job.job_products.each do |jp|
      jp.lender = build(:lender)
  		jp.worker = build(:user)
  	end
  	job.save!
  end

end
