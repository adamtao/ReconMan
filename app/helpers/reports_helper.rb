module ReportsHelper
  def report_field(task, field)
    case field
    when :billed
      image_tag("check.png", alt: "X", size: "16x16") if task.billed?
    when :file_number
      link_to(task.file_number, task.job)
    else
      task.send(field)
    end
  end
end
