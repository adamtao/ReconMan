class ReportsController < ApplicationController
  before_filter :load_report

  def index
  end

  def show
    respond_to do |format|
      format.html
      format.xls {
        send_data(
          @report.to_xls,
          type: "text/xls; charset=utf-8;",
          filename: @report.title.parameterize + ".xls"
        )
      }
    end
  end

  def mark_billed
    @report.mark_all_billed!
    flash[:notice] = "All the following jobs have been marked as billed."
    render action: 'show'
  end

  private

  def load_report
    @report = params[:report].present? ? Report.new(report_params) : Report.new
  end

  def report_params
    params.require(:report).permit(
      :job_status,
      :lender_id,
      :client_id,
      :start_on,
      :end_on,
      :exclude_billed,
      :show_pricing
    )
  end
end
