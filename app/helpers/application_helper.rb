module ApplicationHelper

  def errors_for(f)
    if f.object.errors.any?
      content_tag(:ul, f.object.errors.full_messages.uniq.map{|msg| content_tag(:li, msg)}.join.html_safe )
    end
  end

end
