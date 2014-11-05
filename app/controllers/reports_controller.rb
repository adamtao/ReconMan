class ReportsController < ApplicationController
  def index
    @report = Report.new
  end

  def show
    @report = Report.new(report_params)
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
