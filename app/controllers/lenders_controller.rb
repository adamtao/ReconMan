class LendersController < ApplicationController
  before_action :set_lender, only: [:show, :edit, :update, :merge, :destroy]

  def index
    @top_lenders = Lender.joins(:tasks).
      where.not(tasks: { workflow_state: 'complete'}).
      group(:id, :lender_id).
      order("count(lender_id) desc").
      limit(10)
    @lenders = Lender.order(:name)
  end

  def show
    @current_jobs = Job.where(id: @lender.tasks.where.not(workflow_state: 'complete').pluck(:job_id).uniq).
      includes(:tasks).
      order("tasks.due_on ASC").order("jobs.created_at ASC").
      page(params[:page])
  end

  def new
    @lender = Lender.new
  end

  def create
    @lender = Lender.new(lender_params)
    if @lender.save
      redirect_to @lender, notice: "Lender created successfully."
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @lender.update_attributes(lender_params)
      redirect_to @lender, notice: "Lender updated successfully."
    else
      render action: 'edit'
    end
  end

  def merge
    other_lender = Lender.find(params[:merge_with_id])
    @lender.merge_with!(other_lender)
    redirect_to @lender, notice: "The lenders were merged."
  end

  def destroy
    @lender.destroy
    respond_to do |format|
      format.html { redirect_to lenders_url, notice: 'Lender was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_lender
    @lender = Lender.find(params[:id])
  end

  def lender_params
    params.require(:lender).permit(:name)
  end
end
