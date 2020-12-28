require 'rails_helper'

describe Job do

  before(:all) do
    Product.delete_all
    @tracking_product = create(:tracking_product)
    @search_product   = create(:search_product)
    @special_product  = create(:special_product)
    @documentation_product = create(:documentation_product)
  end

  describe "general functions" do
    before(:each) {
      @job = create(:job)
      create(:task, job: @job)
    }

    subject { @job }
    it { should respond_to(:dashboard_task) }
    it { should respond_to(:link_name) }
    it { should respond_to(:deed_or_parcel_number) }
    it { should respond_to(:total_price_cents) }

    it ".job_types should include our 4 major job types" do
      jt = Job.job_types
      expect(jt).to include(:tracking)
      expect(jt).to include(:search)
      expect(jt).to include(:special)
      expect(jt).to include(:documentation)
    end

    it "#mark_complete! should record the completion date" do
      @job.mark_complete!

      expect(@job.completed_at).not_to be nil
      expect(@job.current_state).to eq("complete")
    end

    it '#re_open should open a closed job' do
      @job.mark_complete!

      @job.re_open!

      expect(@job.completed_at).to be nil
      expect(@job.current_state).to eq("new")
    end

    it ".dashboard_jobs should include job" do
      expect(Job.dashboard_jobs(user: create(:user), complete: false)).to include(@job)
    end

    it "should have open tasks (tasks)" do
      expect(@job.open_products.length).to be > 0
      expect(@job.open_products.first).to be_instance_of(Task)
    end

    it "should create a new zipcode" do
      expect(Zipcode.exists?(zipcode: @job.zipcode)).to be(true)
    end
  end

  describe "navigating" do
    before do
      @county = create(:county)
      @tracking_tasks = create_list(:tracking_task, 5)
      @tracking_tasks.each_with_index do |task,i|
        task.update_column(:due_on, (i+1).weeks.ago)
        task.job.update_column(:county_id, @county.id)
      end
      @tracking_jobs = @tracking_tasks.map{|tjp| tjp.job}
    end

    it "#next should load the next job in the county" do
      expect(@tracking_jobs.last.next).to eq(@tracking_jobs[3])
    end

    it ".next loads a job after having completed the job" do
      @tracking_jobs.second.update_column(:workflow_state, "complete")

      expect(@tracking_jobs.second.next).to eq(@tracking_jobs.first)
    end
  end

  describe "tracking job_type" do
    before(:all) { @job = build(:tracking_job) }

    it "should initialize with a tracking task" do
      expect(@job.default_tasks).to include(@tracking_product)
      expect(@job.default_task_id).to eq(@tracking_product.id)
    end

    it "#dashboard_task should return one task" do
      setup_job_with_tasks(@job)

      expect(@job.dashboard_task).to be_instance_of(TrackingTask)
      expect(@job.dashboard_task.product).to eq(@tracking_product)
    end
  end

  describe "search job_type" do
    before(:all) { @job = build(:search_job)  }

    it "should initialize with a search task" do
      expect(@job.default_tasks).to include(@search_product)
      expect(@job.default_task_id).to eq(@search_product.id)
    end

    it "#dashboard_task should return one task" do
      setup_job_with_tasks(@job)

      expect(@job.dashboard_task).to be_instance_of(SearchTask)
      expect(@job.dashboard_task.product).to eq(@search_product)
    end
  end

  describe "special job_type" do
    before(:all) { @job = build(:special_job) }

    it "should initialize with a special task" do
      expect(@job.default_tasks).to include(@special_product)
      expect(@job.default_task_id).to eq(@special_product.id)
    end

    it "#dashboard_task should return one task" do
      setup_job_with_tasks(@job)

      expect(@job.dashboard_task).to be_instance_of(SpecialTask)
      expect(@job.dashboard_task.product).to eq(@special_product)
    end
  end

  describe "documentation job_type" do
    before(:all) do
      @job = build(:documentation_job)
    end

    it "should initialize with a document task" do
      expect(@job.default_tasks).to include(@documentation_product)
      expect(@job.default_task_id).to eq(@documentation_product.id)
    end

    it "#dashboard_task should return one task" do
      setup_job_with_tasks(@job)

      expect(@job.dashboard_task).to be_instance_of(DocumentationTask)
      expect(@job.dashboard_task.product).to eq(@documentation_product)
    end
  end

  def setup_job_with_tasks(job)
    job.initialize_tasks
    job.tasks.each do |jp|
      jp.lender = build(:lender)
      jp.worker = build(:user)
    end
    job.save!
  end

end
