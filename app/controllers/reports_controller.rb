class ReportsController < ApplicationController
  def index
    @report = Report.new
  end

  def show
    @report = Report.new(report_params)
  end

  private

  def report_params
    params.require(:report).permit(
      :job_status,
      :lender_id,
      :client_id,
      :start_on,
      :end_on,
      :show_pricing
    )
  end
end
