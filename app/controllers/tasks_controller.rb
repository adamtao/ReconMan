class TasksController < ApplicationController
  before_action :get_type
  before_action :set_job, except: :toggle_billing
  before_action :set_task, except: [:index, :new, :create]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = @job.tasks
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = @klass.new(job: @job)
    @task.lender = Lender.new
    @task.worker = current_user
  end

  # GET /tasks/1/edit
  # TODO: The edit form (html) has a separate copy of the form.
  # The reason has to do with the fancy javascript in the create form
  # which shows/hides fields based on the select job type. This was
  # causing problems in the form. The correct way to do it is to
  # insert/remove those fields instead of showing/hiding them.
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = @klass.new(task_params)
    @task.job = @job
    @task.creator = current_user
    respond_to do |format|
      if @task.save
        format.html { redirect_to @job, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    @task.modifier = current_user
    search_log = build_search_log
    respond_to do |format|
      if @task.update(task_params)
        if task_params[:search_url] && !@task.search_url.blank?
          search_log.save
        elsif task_params[:new_deed_of_trust_number].present? && task_params[:recorded_on].present?
          if @task.search_logs.length > 0
            search_log = @task.search_logs.last
          end
          search_log.status = "Cleared"
          search_log.save
          @task.reload
          unless @task.workflow_state == 'complete'
            @task.mark_complete!
          end
        end
        format.html { redirect_to @job, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /job/id/tasks/id/toggle.js
  def toggle
    @task.toggle!
    respond_to do |format|
      format.html { redirect_to @job, notice: "The #{@task.product.name} for this job is complete." }
      format.js { head :ok }
    end
  end

  # POST /tasks/:id/toggle_billing
  def toggle_billing
    @task.update_column(:billed, !@task.billed?)
    head :ok
  end

  # GET /tasks/:id/first_notice_cover_letter
  def first_notice_cover_letter
    render layout: 'letterhead'
  end

  # PATCH /tasks/:id/first_notice_sent
  def first_notice_sent
    @task.send_first_notice!
    redirect_to @job
  end

  # PATCH /tasks/:id/second_notice_sent
  def second_notice_sent
    @task.send_second_notice!
    redirect_to @job
  end

  # GET /job/:job_id/task/:id/research
  def research
    if @task.search_url.present?
      redirect_to @task.search_url
      build_search_log.save
    else
      redirect_to @job, notice: "The search URL is missing. Provide it below."
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to @job, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def get_type
      @type = "task"
      if request.path.match(/\/(\w*\_task)/)
        @type = $1
      end
      @klass = @type.gsub(/\_/, ' ').titleize.gsub(/\s/, '').constantize
    end

    def set_job
      @job = Job.find(params[:job_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = @klass.find(params[:id])
    end

    def build_search_log
      SearchLog.new(
        status: "Not Cleared",
        task: @task,
        user: current_user
      )
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(@type.to_sym).permit(:product_id, :search_url,
          :worker_id,
          :due_on,
          :deed_of_trust_number,
          :beneficiary_name,
          :beneficiary_account,
          :payoff_amount,
          :developer,
          :price,
          :parcel_number,
          :parcel_legal_description,
          :new_deed_of_trust_number,
          :docs_delivered_on,
          :recorded_on,
          :reconveyance_filed,
          :job_complete,
          :lender_id,
          lender_attributes: [ :name ]
        )
    end
end
